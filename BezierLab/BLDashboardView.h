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

#import <Cocoa/Cocoa.h>

// Constants Definitions
enum BLPathType { BLPathTypeSqare = 0, BLPathTypeCircle, BLPathTypeArc, BLPathTypeLine };

enum BLLineCapStyle { BLLineCapStyleButtLine = 0, BLLineCapStyleSquareLine, BLLineCapStyleRoundLine };

enum BLDashStyle { BLDashTyleSolid = 0, BLDashTyle5_5, BLDashTyle8_3_8, BLDashTyle9_6_3 };

// BLDashboardView class
@interface BLDashboardView : NSView

#pragma mark Outlets
@property ( assign ) IBOutlet NSColorWell* _lineColorWell;
@property ( assign ) IBOutlet NSColorWell* _fillColorWell;
@property ( assign ) IBOutlet NSColorWell* _backgroundColorWell;

@property ( assign ) IBOutlet NSMatrix* _pathTypeMatrix;
@property ( assign ) IBOutlet NSMatrix* _lineCapStyleMatrix;
@property ( assign ) IBOutlet NSMatrix* _dashTypeMatrix;

@property ( assign ) IBOutlet NSButton* _isFilledButton;

@property ( assign ) IBOutlet NSSlider* _angleSlider;
@property ( assign ) IBOutlet NSSlider* _zoomSlider;
@property ( assign ) IBOutlet NSSlider* _lineWidthSlider;

#pragma mark Instance variables
@property ( assign ) enum BLPathType _pathType;
@property ( assign ) enum BLLineCapStyle _lineCapStyle;
@property ( assign ) enum BLDashStyle _dashStyle;

@property ( assign ) BOOL _isFilled;

@property ( assign ) CGFloat _angle;
@property ( assign ) CGFloat _zoom;
@property ( assign ) CGFloat _lineWidth;

@property ( retain ) NSColor* _lineColor;
@property ( retain ) NSColor* _fillColor;
@property ( retain ) NSColor* _backgroundColor;

#pragma mark IBActions
- ( IBAction ) 

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