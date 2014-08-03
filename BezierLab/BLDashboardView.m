///:
/*****************************************************************************
 **                                                                         **
 **                               .======.                                  **
 **                               | INRI |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                      .========'      '========.                         **
 **                      |   _      xxxx      _   |                         **
 **                      |  /_;-.__ / _\  _.-;_\  |                         **
 **                      |     `-._`'`_/'`.-'     |                         **
 **                      '========.`\   /`========'                         **
 **                               | |  / |                                  **
 **                               |/-.(  |                                  **
 **                               |\_._\ |                                  **
 **                               | \ \`;|                                  **
 **                               |  > |/|                                  **
 **                               | / // |                                  **
 **                               | |//  |                                  **
 **                               | \(\  |                                  **
 **                               |  ``  |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                   \\    _  _\\| \//  |//_   _ \// _                     **
 **                  ^ `^`^ ^`` `^ ^` ``^^`  `^^` `^ `^                     **
 **                                                                         **
 **                       Copyright (c) 2014 Tong G.                        **
 **                          ALL RIGHTS RESERVED.                           **
 **                                                                         **
 ****************************************************************************/

#import "BLDashboardView.h"

// BLDashboardView class
@implementation BLDashboardView

#pragma mark Outlets
@synthesize _lineColorWell;
@synthesize _fillColorWell;
@synthesize _backgroundColorWell;

@synthesize _pathTypeMatrix;
@synthesize _lineCapStyleMatrix;
@synthesize _dashTypeMatrix;

@synthesize _isFilledButton;

@synthesize _angleSlider;
@synthesize _zoomSlider;
@synthesize _lineWidthSlider;

#pragma mark Instance variables
@synthesize _bezierPath;

@synthesize _pathType;
@synthesize _lineCapStyle;
@synthesize _dashStyle;

@synthesize _isFilled;

@synthesize _angle;
@synthesize _zoom;
@synthesize _lineWidth;

@synthesize _lineColor;
@synthesize _fillColor;
@synthesize _backgroundColor;

#pragma mark Conforms <NSNibAwaking> protocol
- ( void ) awakeFromNib
    {
    self._bezierPath = [ NSBezierPath bezierPath ];

    self._lineColor = [ _lineColorWell color ];
    self._fillColor = [ _fillColorWell color ];
    self._backgroundColor = [ _backgroundColorWell color ];

    self._isFilled = [ _isFilledButton state ];

    self._angle = [ _angleSlider doubleValue ];
    self._zoom = [ _zoomSlider doubleValue ];
    self._lineWidth = floorl( [ _zoomSlider doubleValue ] );

    self._pathType = ( enum BLPathType )[ _pathTypeMatrix selectedTag ];
    self._lineCapStyle = ( enum BLLineCapStyle )[ _lineCapStyleMatrix selectedTag ];
    self._dashStyle = ( enum BLDashStyle )[ _dashTypeMatrix selectedTag ];

    _isDragging = NO;
    }

#pragma mark Overrides
- ( BOOL ) isFlipped
    {
    return YES;
    }

- ( BOOL ) acceptsFirstResponder
    {
    return YES;
    }

- ( void ) drawRect: ( NSRect )_Rect
    {
    [ self lockFocus ];

    [ self._bezierPath removeAllPoints ];

    NSRect bounds = [ self bounds ];
    [ self._backgroundColor set ];
    NSRectFill( bounds );

    [ self._lineColor setStroke ];
    self._isFilled ? [ self._fillColor setFill ] : [ self._backgroundColor setFill ];

    [ self._bezierPath setLineWidth: self._lineWidth ];
    [ self._bezierPath setLineCapStyle: ( NSLineCapStyle )self._lineCapStyle ];
    [ self._bezierPath setLineDash: _dashArray count: _dashCount phase: .0f ];

    switch ( [ self._pathTypeMatrix selectedTag ] )
        {
    case BLPathTypeSquare:
            {
            CGFloat initialSideLengthOfSquare = 100;
            CGFloat actualSideLengthOfSquare = initialSideLengthOfSquare * self._zoom;

            NSRect square = NSMakeRect( NSMaxX( bounds ) / 2 - actualSideLengthOfSquare / 2
                                      , NSMaxY( bounds ) / 2 - actualSideLengthOfSquare / 2
                                      , actualSideLengthOfSquare, actualSideLengthOfSquare
                                      );

            [ self._bezierPath appendBezierPathWithRect: square ];
            } break;

    case BLPathTypeCircle:
            {
            CGFloat initialDiameterOfCircle = 100;
            CGFloat actualDiameterOfCircle = initialDiameterOfCircle * self._zoom;
            NSRect circleInRect = NSMakeRect( NSMaxX( bounds ) / 2 - actualDiameterOfCircle / 2
                                            , NSMaxY( bounds ) / 2 - actualDiameterOfCircle / 2
                                            , actualDiameterOfCircle, actualDiameterOfCircle
                                            );

            [ self._bezierPath appendBezierPathWithOvalInRect: circleInRect ];
            } break;

    case BLPathTypeArc:
            {
            // TODO:
            } break;

    case BLPathTypeLine:
            {
            CGFloat initialLengthOfLine = 100;
            CGFloat actualLengthOfLine = initialLengthOfLine * self._zoom;

            NSPoint startPoint = NSMakePoint( ( NSMaxX( bounds ) - actualLengthOfLine ) / 2
                                            , ( NSMaxY( bounds ) - self._lineWidth ) / 2
                                            );

            [ self._bezierPath moveToPoint: startPoint ];
            [ self._bezierPath lineToPoint: NSMakePoint( startPoint.x + actualLengthOfLine, startPoint.y ) ];
            } break;
        }

    NSAffineTransform* rotation = [ NSAffineTransform transform ];
    NSAffineTransform* translation = [ NSAffineTransform transform ];

    [ rotation rotateByDegrees: self._angle ];
    [ translation translateXBy: NSMaxX( bounds ) / 2 yBy: NSMaxY( bounds ) / 2 ];
#if 0
    [ rotation concat ];
    [ translation concat ];

    // Undo rotation!
    [ rotation invert ];[ rotation concat ];
    // Undo tranlation!
    [ translation invert ];[ translation concat ];
#endif

    if ( [ [ NSGraphicsContext currentContext ] isDrawingToScreen ] )
        [ self drawGrid ];

    [ self._bezierPath stroke ];
    [ self._bezierPath fill ];

    [ self unlockFocus ];
    }

- ( void ) mouseDown: ( NSEvent* )_Event
    {
    NSPoint clickLocation = [ self convertPoint: [ _Event locationInWindow ] fromView: nil ];

    if ( [ self._bezierPath containsPoint: clickLocation ] )
        {
        _isDragging = YES;

        _lastDraggedLocation = clickLocation;
        }
    }

- ( void ) mouseDragged: ( NSEvent* )_Event
    {
    if ( _isDragging )
        {
        NSPoint newDraggedLocation = [ self convertPoint: [ _Event locationInWindow ] fromView: nil ];

        [ self offsetLocation: [ self _bezierPath ]
                          byX: newDraggedLocation.x - _lastDraggedLocation.x
                          byY: newDraggedLocation.y - _lastDraggedLocation.y ];
        }
    }

- ( void ) offsetLocation: ( NSBezierPath* )_Path byX: ( CGFloat )_X byY: ( CGFloat )_Y
    {
    NSAffineTransformStruct affineTransformStruct = { 1.f, 0.f, 0.f, 1.f, _X, _Y };
    NSAffineTransform* transform = [ NSAffineTransform transform ];

    

#if 0
    for ( int index = 0; index < [ self._bezierPath elementCount ]; index++ )
        {
        NSPoint points[ 3 ];
        NSBezierPathElement element = [ _Path elementAtIndex: index associatedPoints: points ];

        if ( element != NSCurveToBezierPathElement )
             points[ 0 ] = NSMakePoint( points[ 0 ].x + _X, points[ 0 ].y + _Y );
        else
            {
            for ( int i = 0; i < 3; i++ )
                points[ i ] = NSMakePoint( points[ 0 ].x + _X, points[ 0 ].y + _Y );
            }

        [ _Path setAssociatedPoints: points atIndex: index ];
        }
#endif
    }

- ( void ) mouseUp: ( NSEvent* )_Event
    {

    }

- ( void ) dealloc
    {
    [ _bezierPath release ];
    _bezierPath = nil;

    [ _lineColor release ];
    [ _fillColor release ];
    [ _backgroundColor release ];

    _lineColor = nil;
    _fillColor = nil;
    _backgroundColor = nil;

    [ super dealloc ];
    }

#pragma mark Accessors
- ( void ) setCurrentLocation: ( NSPoint )_Location
    {
    if ( !NSEqualPoints( _Location, self->_currentLocation ) )
        {
        self->_currentLocation = _Location;

        [ self setNeedsDisplay: YES ];
        }
    }

- ( NSPoint ) currentLocation
    {
    return self->_currentLocation;
    }

- ( void ) setLastDraggedLocation: ( NSPoint )_Location
    {
    if ( !NSEqualPoints( _Location, self->_lastDraggedLocation ) )
        {
        self->_lastDraggedLocation = _Location;

        [ self setNeedsDisplay: YES ];
        }
    }

#pragma mark IBActions
- ( IBAction ) changedPathType: ( id )_Sender
    {
    self._pathType = ( enum BLPathType )[ ( NSMatrix* )_Sender selectedTag ];

    if ( self._pathType == BLPathTypeArc || self._pathType == BLPathTypeLine )
        [ self._isFilledButton setEnabled: NO ];
    else
        [ self._isFilledButton setEnabled: YES ];

    [ self setNeedsDisplay: YES ];
    }

- ( IBAction ) changedLineCapStyle: ( id )_Sender
    {
    self._lineCapStyle = ( enum BLLineCapStyle )[ ( NSMatrix* )_Sender selectedTag ];
    [ self setNeedsDisplay: YES ];
    }

- ( IBAction ) changedDashType: ( id )_Sender
    {
    self._dashStyle = ( enum BLDashStyle )[ ( NSMatrix* )_Sender selectedTag ];

    switch ( [ ( NSMatrix* )_Sender selectedTag ] )
        {
    case BLDashTyleSolid:
            {
            _dashCount = 0;
            } break;

    case BLDashTyle5_5:
            {
            _dashCount = 2;

            _dashArray[ 0 ] = 5.f;
            _dashArray[ 1 ] = 5.f;
            } break;

    case BLDashTyle8_3_8:
            {
            _dashCount = 3;

            _dashArray[ 0 ] = 8.f;
            _dashArray[ 1 ] = 3.f;
            _dashArray[ 2 ] = 8.f;
            } break;

    case BLDashTyle9_6_3:
            {
            _dashCount = 3;

            _dashArray[ 0 ] = 9.f;
            _dashArray[ 1 ] = 6.f;
            _dashArray[ 2 ] = 3.f;
            } break;
        }

    [ self setNeedsDisplay: YES ];
    }

- ( IBAction ) changedFilled: ( id ) _Sender
    {
    self._isFilled = [ ( NSButton* )_Sender state ];
    [ self setNeedsDisplay: YES ];
    }

- ( IBAction ) changedLineColor: ( id )_Sender
    {
    self._lineColor = [ ( NSColorWell* )_Sender color ];
    [ self setNeedsDisplay: YES ];
    }

- ( IBAction ) changedFillColor: ( id )_Sender
    {
    self._fillColor = [ ( NSColorWell* )_Sender color ];
    [ self setNeedsDisplay: YES ];
    }

- ( IBAction ) changedBackgroundColor: ( id )_Sender
    {
    self._backgroundColor = [ ( NSColorWell* )_Sender color ];
    [ self setNeedsDisplay: YES ];
    }

- ( IBAction ) changedAngle: ( id )_Sender
    {
    self._angle = [ ( NSSlider* )_Sender doubleValue ];
    [ self setNeedsDisplay: YES ];
    }

- ( IBAction ) changeZoom: ( id )_Sender
    {
    self._zoom = [ ( NSSlider* )_Sender doubleValue ];
    [ self setNeedsDisplay: YES ];
    }

- ( IBAction ) changeLineWidth: ( id )_Sender
    {
    self._lineWidth = [ ( NSSlider* )_Sender doubleValue ];
    [ self setNeedsDisplay: YES ];
    }

- ( IBAction ) drawIntoPDF: ( id )_Sender
    {
    dispatch_async( dispatch_get_main_queue()
        , ^( void )
            {
            NSSavePanel* savePanel = [ NSSavePanel savePanel ];

            [ savePanel beginSheetModalForWindow: [ self window ]
                               completionHandler:
                ^( NSInteger _Result )
                    {
                    NSData* PDFData = [ self dataWithPDFInsideRect: [ self visibleRect ] ];

                    [ PDFData writeToURL: [ savePanel URL ] atomically: YES ];
                    } ];
            } );
    }

- ( void ) drawGrid
    {
    if ( [ self lockFocusIfCanDraw ] )
        {
        CGFloat width = [ self bounds ].size.width;
        CGFloat height = [ self bounds ].size.height;
        CGFloat horizontalGridSpacing = height / 3;
        CGFloat verticalGridSpacing = width / 4;

        [ [ [ NSColor lightGrayColor ] colorWithAlphaComponent: .5 ] set ];
        NSBezierPath* gridPath = [ NSBezierPath bezierPath ];
        for ( int hor = 0; hor < height / horizontalGridSpacing; hor++ )
            {
            [ gridPath moveToPoint: NSMakePoint( 0, hor * horizontalGridSpacing ) ];
            [ gridPath lineToPoint: NSMakePoint( NSMaxX( self.bounds ), hor * horizontalGridSpacing ) ];
            }

        for ( int ver = 0; ver < width / verticalGridSpacing; ver++ )
            {
            [ gridPath moveToPoint: NSMakePoint( ver * verticalGridSpacing, 0 ) ];
            [ gridPath lineToPoint: NSMakePoint( ver * verticalGridSpacing, NSMaxY( self.bounds ) ) ];
            }

        [ gridPath stroke ];

        [ self unlockFocus ];
        }
    }

@end // BLDashboardView

/////////////////////////////////////////////////////////////////////////////

/****************************************************************************
 **                                                                        **
 **      _________                                      _______            **
 **     |___   ___|                                   / ______ \           **
 **         | |     _______   _______   _______      | /      |_|          **
 **         | |    ||     || ||     || ||     ||     | |    _ __           **
 **         | |    ||     || ||     || ||     ||     | |   |__  \          **
 **         | |    ||     || ||     || ||     ||     | \_ _ __| |  _       **
 **         |_|    ||_____|| ||     || ||_____||      \________/  |_|      **
 **                                           ||                           **
 **                                    ||_____||                           **
 **                                                                        **
 ***************************************************************************/
///:~