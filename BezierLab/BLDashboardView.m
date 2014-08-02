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
    }

#pragma mark Overrides
- ( BOOL ) isFlipped
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
#endif
    [ self._bezierPath stroke ];
    [ self._bezierPath fill ];

    // Undo rotation!
    [ rotation invert ];[ rotation concat ];
    // Undo tranlation!
    [ translation invert ];[ translation concat ];

    [ self unlockFocus ];
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
    
    [ self setNeedsDisplayInRect: NSMakeRect( 33, 33, 200, 200 ) ];
    [ self setNeedsDisplayInRect: NSMakeRect( 20, 20, 200, 200 ) ];
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