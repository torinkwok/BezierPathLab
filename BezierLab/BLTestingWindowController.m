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
#import "BWToolkitFramework/BWToolkitFramework.h"
#import "ShortcutRecorder/SRRecorderControl.h"

// BLTestingWindowController class
@implementation BLTestingWindowController

@synthesize _testPanel;
@synthesize _testWindow;

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
    if ( [ [ self window ] isKindOfClass: [ NSPanel class ] ] )
        {
        [ ( NSPanel* )[ self window ] setBecomesKeyOnlyIfNeeded: YES ];
        [ ( NSPanel* )[ self window ] setFloatingPanel: YES ];
        [ ( NSPanel* )[ self window ] setWorksWhenModal: YES ];

        [ NOTIFICATION_CENTER addObserver: self
                                 selector: @selector( showPanel: )
                                     name: @"showPanel:"
                                   object: nil ];
        }
    }

- ( void ) windowWillClose: ( NSNotification* )_Notif
    {
    NSLog( @"Will be close %@   #%@", [ _Notif object ], [ [ _Notif object ] title ] );
    }

- ( IBAction ) showPanel: ( id )_Sender
    {
    NSLog( @"TestPanel: %@", self._testPanel );
    NSLog( @"TestWindow: %@", self._testWindow );

    [ self._testPanel orderFront: self ];
    [ self._testWindow orderFront: self ];
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