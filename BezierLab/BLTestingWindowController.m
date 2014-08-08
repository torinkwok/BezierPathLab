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

#import "BLTestingWindowController.h"
#import "BGHUDAppKit/BGHUDAppKit.h"
#import "ChromiumTabs/ChromiumTabs.h"
#import "ShortcutRecorder/SRRecorderControl.h"
#import "BLContentView.h"

// BLTestingWindowController class
@implementation BLTestingWindowController

@synthesize _testPanel;
@synthesize _window_1;
@synthesize _window_2;

#pragma mark Initializers
+ ( id ) testingWindowController
    {
    return [ [ [ [ self class ] alloc ] init ] autorelease ];
    }

- ( id ) init
    {
    if ( self = [ super initWithWindowNibName: @"BLTestingWindow" ] )
        {
        // TODO:
        }

    return self;
    }

#pragma mark Conforms <NSNibAwaking> protocol
- ( void ) awakeFromNib
    {
    [ self._window_1 setMinSize: NSMakeSize( 100, 100 ) ];
    [ self._window_1 setMaxSize: NSMakeSize( 600, 600 ) ];

    [ self._window_2 setMinSize: NSMakeSize( 100, 100 ) ];
    [ self._window_2 setMaxSize: NSMakeSize( 600, 600 ) ];

    [ self._window_1 setAspectRatio: NSMakeSize( 300, 400 ) ];
    [ self._window_2 setContentAspectRatio: NSMakeSize( 300, 400 ) ];

    [ self._testPanel setExcludedFromWindowsMenu: NO ];
    }

- ( void ) windowDidBecomeKey: ( NSNotification* )_Notif
    {
    if ( [ _Notif object ] == self._testPanel )
        [ self._testPanel center ];
    }

- ( IBAction ) resizeCustomeWindow: ( id )_Sender
    {
    NSRect currentFrame = [ self._window_1 frame ];
    [ self._window_1 setFrame: NSMakeRect( currentFrame.origin.x - 300, currentFrame.origin.y - 300
                                           , 400, 400 )
                        display: YES
                        animate: YES ];
    }

- ( IBAction ) zoom: ( id )_Sender
    {
    [ self._window_1 performZoom: self ];
    }

#pragma mark Conforms <NSWindowDelegate> protocol
- ( void ) windowWillStartLiveResize: ( NSNotification* )_Notif
    {
    NSLog( @"Is in live resize: %@", [ [ _Notif object ] inLiveResize ] ? @"YES" : @"NO" );
    }

- ( void ) windowDidEndLiveResize: ( NSNotification* )_Notif
    {
    NSLog( @"Is in live resize: %@", [ [ _Notif object ] inLiveResize ] ? @"YES" : @"NO" );
    }

- ( NSSize ) windowWillResize: ( NSWindow* )_Window
                       toSize: ( NSSize )_FrameSize
    {
    __CAVEMEN_DEBUGGING__PRINT_WHICH_METHOD_INVOKED__;
    return _Window.frame.size;
    }

@end // BLTestingWindowController

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