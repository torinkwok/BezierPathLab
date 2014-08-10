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

// Keys for Preferences
NSString* const BLUserDefaultsKeyLineColor = @"BLUserDefaultsKeyLineColor";
NSString* const BLUserDefaultsKeyFillColor = @"BLUserDefaultsKeyFillColor";
NSString* const BLUserDefaultsKeyBackgroundColor = @"BLUserDefaultsKeyBackgroundColor";

NSString* const BLUserDefaultsKeyAngle = @"BLUserDefaultsKeyAngle";
NSString* const BLUserDefaultsKeyZoom = @"BLUserDefaultsKeyZoom";
NSString* const BLUserDefaultsKeyLineWidth = @"BLUserDefaultsKeyLineWidth";

NSString* const BLUserDefaultsKeyIsFilled = @"BLUserDefaultsKeyIsFilled";

NSString* const BLUserDefaultsKeyPathType = @"BLUserDefaultsKeyPathType";
NSString* const BLUserDefaultsKeyLineCapStyle = @"BLUserDefaultsKeyLineCapStyle";
NSString* const BLUserDefaultsKeyDashStyle = @"BLUserDefaultsKeyDashStyle";

NSString* const BLUserDefaultsKeyShapeLocation = @"BLUserDefaultsKeyShapeLocation";

NSString* const BLUserDefaultsKeyKeyEquivalent = @"BLUserDefaultsKeyKeyEquivalent";
NSString* const BLUserDefaultsKeyKeyEquivalentModifier = @"BLUserDefaultsKeyKeyEquivalentModifier";

// BLDashboardView class
@implementation BLDashboardView
    {
    // Handling dragged
    BOOL _isDragging;
    NSPoint _initalOriginOfShapes;
    NSPoint _currentLocation;
    NSPoint _lastDraggedLocation;

    NSRect _rectForCurrentBezierPath;
    }

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

@synthesize _contextualMenu;

- ( void ) appWillBeTerminated: ( NSNotification* )_Notif
    {
    [ USER_DEFAULTS setObject: @[ [ NSNumber numberWithDouble: _currentLocation.x ]
                                , [ NSNumber numberWithDouble: _currentLocation.y ] ]
                       forKey: BLUserDefaultsKeyShapeLocation ];
    }

#pragma mark Conforms <NSUserInterfaceValidations> protocol
- ( BOOL ) validateUserInterfaceItem: ( id <NSUserInterfaceValidations> )_Item
    {
    SEL action = [ ( NSMenuItem* )_Item action ];

    if ( ( action == @selector( moveUp: ) || action == @selector( moveDown: ) || action == @selector( moveLeft: ) || action == @selector( moveRight: ) )
            && ( self.window.firstResponder == self ) )
        return YES;

    return NO;
    }

- ( BOOL ) validateMenuItem: ( NSMenuItem* )_MenuItem
    {
    return YES;
    }

#pragma mark Conforms <NSNibAwaking> protocol
- ( void ) awakeFromNib
    {
    [ NOTIFICATION_CENTER addObserver: self
                             selector: @selector( appWillBeTerminated: )
                                 name: NSApplicationWillTerminateNotification
                               object: nil ];

    self._bezierPath = [ NSBezierPath bezierPath ];

#if 1   // TODO: To take advantage of NSUserDefaultController in nib file.
    [ self._lineColorWell setColor: [ NSUnarchiver unarchiveObjectWithData: [ USER_DEFAULTS objectForKey: BLUserDefaultsKeyLineColor ] ] ];
    [ self._fillColorWell setColor: [ NSUnarchiver unarchiveObjectWithData: [ USER_DEFAULTS objectForKey: BLUserDefaultsKeyFillColor ] ] ];
    [ self._backgroundColorWell setColor: [ NSUnarchiver unarchiveObjectWithData: [ USER_DEFAULTS objectForKey: BLUserDefaultsKeyBackgroundColor ] ] ];

    [ self._isFilledButton setState: [ USER_DEFAULTS boolForKey: BLUserDefaultsKeyIsFilled ] ];

    self._lineColor = [ self._lineColorWell color ];
    self._fillColor = [ self._fillColorWell color ];
    self._backgroundColor = [ self._backgroundColorWell color ];

    self._isFilled = [ _isFilledButton state ];
#endif


#if 1   // TODO: To take advantage of NSUserDefaultController in nib file.

    /* If a value from argument domain greater than maximum value in slider,
     * the maximum value will be taken by Cocoa. */
    [ _angleSlider setDoubleValue: [ USER_DEFAULTS doubleForKey: BLUserDefaultsKeyAngle ] ];
    [ _zoomSlider setDoubleValue: [ USER_DEFAULTS doubleForKey: BLUserDefaultsKeyZoom ] ];
    [ _lineWidthSlider setDoubleValue: [ USER_DEFAULTS doubleForKey: BLUserDefaultsKeyLineWidth ] ];

    self._angle = [ _angleSlider doubleValue ];
    self._zoom = [ _zoomSlider doubleValue ];
    self._lineWidth = floorl( [ _lineWidthSlider doubleValue ] );
#endif

#if 1   // TODO: To take advantage of NSUserDefaultController in nib file.
    [ _pathTypeMatrix selectCellAtRow: ( [ USER_DEFAULTS integerForKey: BLUserDefaultsKeyPathType ] > 3 ) ? BLPathTypeLine : [ USER_DEFAULTS integerForKey: BLUserDefaultsKeyPathType ] column: 0 ];
    [ _lineCapStyleMatrix selectCellAtRow: ( [ USER_DEFAULTS integerForKey: BLUserDefaultsKeyLineCapStyle ] > 2 ) ? BLLineCapStyleSquareLine : [ USER_DEFAULTS integerForKey: BLUserDefaultsKeyLineCapStyle ] column: 0 ];
    [ _dashTypeMatrix selectCellAtRow: ( [ USER_DEFAULTS integerForKey: BLUserDefaultsKeyDashStyle ] > 3 ) ? BLDashTyle9_6_3 : [ USER_DEFAULTS integerForKey: BLUserDefaultsKeyDashStyle ] column: 0 ];

    self._pathType = ( enum BLPathType )[ _pathTypeMatrix selectedTag ];
    self._lineCapStyle = ( enum BLLineCapStyle )[ _lineCapStyleMatrix selectedTag ];
    [ self setDashStyle: ( enum BLDashStyle )[ _dashTypeMatrix selectedTag ] ];
#endif
    _isDragging = NO;

    CGFloat initialWidthOfRectWrappingShape = 100;
    CGFloat initialHeightOfRectWrappingShape = 100;

    CGFloat actualWidthOfRectWrappingShape = initialWidthOfRectWrappingShape * self._zoom;
    CGFloat actualHeightOfRectWrappingShape = initialHeightOfRectWrappingShape * self._zoom;

    _initalOriginOfShapes = NSMakePoint( ( NSMaxX( self.bounds ) - actualWidthOfRectWrappingShape ) / 2
                                       , ( NSMaxY( self.bounds ) - actualHeightOfRectWrappingShape ) / 2
                                       );

    [ USER_DEFAULTS registerDefaults:
        @{ BLUserDefaultsKeyShapeLocation : @[ [ NSNumber numberWithDouble: _initalOriginOfShapes.x ]
                                             , [ NSNumber numberWithDouble: _initalOriginOfShapes.y ]
                                             ] } ];

    // Archived the initialOriginOfShapes from the user defualts database.
    _currentLocation = NSMakePoint( [ [ USER_DEFAULTS arrayForKey: BLUserDefaultsKeyShapeLocation ][ 0 ] doubleValue ]
                                  , [ [ USER_DEFAULTS arrayForKey: BLUserDefaultsKeyShapeLocation ][ 1 ] doubleValue ]
                                  );

    _lastDraggedLocation = NSZeroPoint;
    _rectForCurrentBezierPath = NSZeroRect;
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

            _rectForCurrentBezierPath = NSMakeRect( _currentLocation.x
                                                  , _currentLocation.y
                                                  , actualSideLengthOfSquare, actualSideLengthOfSquare
                                                  );

            [ self._bezierPath appendBezierPathWithRect: _rectForCurrentBezierPath ];
            } break;

    case BLPathTypeCircle:
            {
            CGFloat initialDiameterOfCircle = 100;
            CGFloat actualDiameterOfCircle = initialDiameterOfCircle * self._zoom;
            _rectForCurrentBezierPath = NSMakeRect( _currentLocation.x
                                                  , _currentLocation.y
                                                  , actualDiameterOfCircle, actualDiameterOfCircle
                                                  );

            [ self._bezierPath appendBezierPathWithOvalInRect: _rectForCurrentBezierPath ];
            } break;

    case BLPathTypeArc:
            {
            // TODO:
            } break;

    case BLPathTypeLine:
            {
            CGFloat initialLengthOfLine = 100;
            CGFloat actualLengthOfLine = initialLengthOfLine * self._zoom;

            NSPoint startPoint = NSMakePoint( _currentLocation.x
                                            , _currentLocation.y
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

    if ( self._isFilled )
        {
        if ( [ [ NSGraphicsContext currentContext ] isDrawingToScreen ] )
            [ self drawGrid ];

        [ self._bezierPath stroke ];
        [ self._bezierPath fill ];
        }
    else
        {
        [ self._bezierPath fill ];

        if ( [ [ NSGraphicsContext currentContext ] isDrawingToScreen ] )
            [ self drawGrid ];

        [ self._bezierPath stroke ];
        }

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
    else
        [ NSMenu popUpContextMenu: self._contextualMenu
                        withEvent: _Event
                          forView: self ];
    }

- ( void ) mouseDragged: ( NSEvent* )_Event
    {
    if ( _isDragging )
        {
        NSPoint newDraggedLocation = [ self convertPoint: [ _Event locationInWindow ] fromView: nil ];
        CGFloat offsetX = newDraggedLocation.x - _lastDraggedLocation.x;
        CGFloat offsetY = newDraggedLocation.y - _lastDraggedLocation.y;

        [ self offsetLocationByX: offsetX byY: offsetY ];

        _lastDraggedLocation = NSMakePoint( _lastDraggedLocation.x + offsetX
                                          , _lastDraggedLocation.y + offsetY
                                          );
        }
    }

- ( void ) mouseUp: ( NSEvent* )_Event
    {
    _isDragging = NO;
    }

- ( void ) keyDown: ( NSEvent* )_Event
    {
    BOOL isHandled = NO;

    NSString* characters = [ _Event charactersIgnoringModifiers ];
    if ( [ characters isEqualToString: @"r" ] )
        {
        isHandled = YES;

        if ( !NSEqualPoints( _rectForCurrentBezierPath.origin, _initalOriginOfShapes ) )
            [ self offsetLocationByX: _initalOriginOfShapes.x - _rectForCurrentBezierPath.origin.x
                                 byY: _initalOriginOfShapes.y - _rectForCurrentBezierPath.origin.y ];
        }

    if ( !isHandled )
        [ super keyDown: _Event ];
    }

- ( IBAction ) moveUp: ( id )_Sender
    {
    [ self offsetLocationByX: 0.f byY: -10.f ];
    }

- ( IBAction ) moveDown: ( id )_Sender
    {
    [ self offsetLocationByX: 0.f byY: 10.f ];
    }

- ( IBAction ) moveLeft: ( id )_Sender
    {
    [ self offsetLocationByX: -10.f byY: 0.f ];
    }

- ( IBAction ) moveRight: ( id )_Sender
    {
    [ self offsetLocationByX: 10.f byY: 0.f ];
    }

- ( void ) offsetLocationByX: ( CGFloat )_X byY: ( CGFloat )_Y
    {
    int invertDeltaY = [ self isFlipped ] ? 1 : -1;
    NSAffineTransformStruct affineTransformStruct = { 1.f, 0.f, 0.f, 1.f, _X, _Y * invertDeltaY };

    NSAffineTransform* transform = [ NSAffineTransform transform ];
    [ transform setTransformStruct: affineTransformStruct ];

    _currentLocation = [ transform transformPoint: _currentLocation ];
    NSRect rectNeededToRefresh = NSMakeRect( _currentLocation.x, _currentLocation.y
                                           , _rectForCurrentBezierPath.size.width
                                           , _rectForCurrentBezierPath.size.height
                                           );

    // Both of the source and destination area, and the area between them need to be redrawn, so union them.
    rectNeededToRefresh = NSInsetRect( NSUnionRect( rectNeededToRefresh, _rectForCurrentBezierPath )
                                     , -self._lineWidth, -self._lineWidth
                                     );

    [ self setNeedsDisplayInRect: rectNeededToRefresh ];
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

- ( void ) invalidateTheShape: ( NSRect )_RectWrappingTheShape
    {
    [ self setNeedsDisplayInRect: NSInsetRect( _RectWrappingTheShape, -self._lineWidth, -self._lineWidth ) ];
    }

#pragma mark IBActions
- ( IBAction ) changedPathType: ( id )_Sender
    {
    self._pathType = ( enum BLPathType )[ ( NSMatrix* )_Sender selectedTag ];

    if ( self._pathType == BLPathTypeArc || self._pathType == BLPathTypeLine )
        [ self._isFilledButton setEnabled: NO ];
    else
        [ self._isFilledButton setEnabled: YES ];

    [ self invalidateTheShape: _rectForCurrentBezierPath ];

    [ USER_DEFAULTS setInteger: self._pathType forKey: BLUserDefaultsKeyPathType ];
    }

- ( void ) setDashStyle: ( enum BLDashStyle )_NewStyle
    {
    self._dashStyle = _NewStyle;

    [ self changedDashType: [ self _dashTypeMatrix ] ];
    }

- ( IBAction ) changedLineCapStyle: ( id )_Sender
    {
    self._lineCapStyle = ( enum BLLineCapStyle )[ ( NSMatrix* )_Sender selectedTag ];
    [ self setNeedsDisplay: YES ];

    [ self invalidateTheShape: _rectForCurrentBezierPath ];

    [ USER_DEFAULTS setInteger: self._lineCapStyle forKey: BLUserDefaultsKeyLineCapStyle ];
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

    [ self invalidateTheShape: _rectForCurrentBezierPath ];

    [ USER_DEFAULTS setInteger: self._dashStyle forKey: BLUserDefaultsKeyDashStyle ];
    }

- ( IBAction ) changedFilled: ( id ) _Sender
    {
    self._isFilled = [ ( NSButton* )_Sender state ];
    [ self invalidateTheShape: _rectForCurrentBezierPath ];

    [ USER_DEFAULTS setBool: self._isFilled forKey: BLUserDefaultsKeyIsFilled ];
    }

- ( IBAction ) changedLineColor: ( id )_Sender
    {
    self._lineColor = [ ( NSColorWell* )_Sender color ];
    [ self invalidateTheShape: _rectForCurrentBezierPath ];

    [ USER_DEFAULTS setObject: [ NSArchiver archivedDataWithRootObject: self._lineColor ] forKey: BLUserDefaultsKeyLineColor ];
    }

- ( IBAction ) changedFillColor: ( id )_Sender
    {
    self._fillColor = [ ( NSColorWell* )_Sender color ];
    [ self invalidateTheShape: _rectForCurrentBezierPath ];

    [ USER_DEFAULTS setObject: [ NSArchiver archivedDataWithRootObject: self._fillColor ] forKey: BLUserDefaultsKeyFillColor ];
    }

- ( IBAction ) changedBackgroundColor: ( id )_Sender
    {
    self._backgroundColor = [ ( NSColorWell* )_Sender color ];
    [ self setNeedsDisplay: YES ];

    [ USER_DEFAULTS setObject: [ NSArchiver archivedDataWithRootObject: self._backgroundColor ] forKey: BLUserDefaultsKeyBackgroundColor ];
    }

- ( IBAction ) changedAngle: ( id )_Sender
    {
    self._angle = [ ( NSSlider* )_Sender doubleValue ];
    [ self invalidateTheShape: _rectForCurrentBezierPath ];

    [ USER_DEFAULTS setDouble: self._angle forKey: BLUserDefaultsKeyAngle ];
    }

- ( IBAction ) changedZoom: ( id )_Sender
    {
    self._zoom = [ ( NSSlider* )_Sender doubleValue ];

    CGFloat actualWidthOfRectWrappingShape = _rectForCurrentBezierPath.size.width;
    CGFloat actualHeightOfRectWrappingShape = _rectForCurrentBezierPath.size.height;

    _initalOriginOfShapes = NSMakePoint( ( NSMaxX( self.bounds ) - actualWidthOfRectWrappingShape ) / 2
                                       , ( NSMaxY( self.bounds ) - actualHeightOfRectWrappingShape ) / 2
                                       );

    NSRect rectNeededToRefresh = NSMakeRect( _rectForCurrentBezierPath.origin.x
                                           , _rectForCurrentBezierPath.origin.y
                                           , _rectForCurrentBezierPath.size.width * self._zoom
                                           , _rectForCurrentBezierPath.size.height * self._zoom
                                           );

    if ( self._pathType == BLPathTypeLine )
        [ self setNeedsDisplay: YES ];
    else
        [ self invalidateTheShape: rectNeededToRefresh ];

    [ USER_DEFAULTS setDouble: self._zoom forKey: BLUserDefaultsKeyZoom ];
    }

- ( IBAction ) changeLineWidth: ( id )_Sender
    {
    self._lineWidth = [ ( NSSlider* )_Sender doubleValue ];
    [ self invalidateTheShape: _rectForCurrentBezierPath ];

    [ USER_DEFAULTS setDouble: self._lineWidth forKey: BLUserDefaultsKeyLineWidth ];
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