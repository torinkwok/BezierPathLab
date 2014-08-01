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