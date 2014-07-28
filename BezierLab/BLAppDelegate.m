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

#import "BLAppDelegate.h"
#import "BLMainWindowController.h"
#import "BLView.h"
#import "BLCompressionSchemesViewController.h"

// BLAppDelegate class
@implementation BLAppDelegate

@synthesize _mainWindowController;

#pragma mark -
#pragma mark Conforms <NSNibLoading> protocol
- ( void ) awakeFromNib
    {
    self._mainWindowController = [ BLMainWindowController mainWindowController ];

    [ self._mainWindowController showWindow: self ];
    }

- ( void ) applicationDidFinishLaunching: ( NSNotification* )_Notification
    {

    }

#pragma mark Testings for NSImage, NSImageRep along with its subclass
- ( IBAction ) testingForImageRep: ( id )_Sender
    {
    [ NOTIFICATION_CENTER postNotificationName: @"TestingForImageRep"
                                        object: self
                                      userInfo: @{ BLViewClickedButtonNotification : _Sender }
                                      ];
    }

- ( IBAction ) checkToSeeIfAViewCanBeDrawn: ( id )_Sender
    {
    [ NOTIFICATION_CENTER postNotificationName: @"TestingForCanBeDrawn"
                                        object: self
                                      userInfo: @{ BLViewClickedButtonNotification : _Sender }
                                      ];
    }

- ( IBAction ) testingForOffscreenDrawn: ( id )_Sender
    {
    NSWindow* mainWindow = [ self._mainWindowController window ];

    //    NSWindow* offscreenWindow = [ [ [ NSWindow alloc ] init ] autorelease ];
    NSWindow* offscreenWindow = [ [ NSWindow alloc ] initWithContentRect: NSMakeRect( 0, 0, mainWindow.frame.size.width, mainWindow.frame.size.height )
                                                               styleMask: NSBorderlessWindowMask
                                                                 backing: NSBackingStoreRetained
                                                                   defer: NO];

    NSView* offscreenView = [ [ BLCompressionSchemesViewController compressionSchemesViewController ] view ];
    [ [ offscreenWindow contentView ] addSubview: offscreenView ];
    [ [ offscreenWindow contentView ] display ];

    NSRect rect = [ offscreenView bounds ];

    if ( [ offscreenWindow.contentView lockFocusIfCanDraw ] )
        {
        NSBitmapImageRep* bitmapImageRep = [ [ [ NSBitmapImageRep alloc ] initWithFocusedViewRect: rect ] autorelease ];
        [ offscreenWindow.contentView unlockFocus ];

        if ( [ mainWindow.contentView lockFocusIfCanDraw ] )
            {
            [ bitmapImageRep drawAtPoint: NSMakePoint( 100, 500 ) ];
            [ mainWindow.contentView unlockFocus ];
            }
        }

    [ offscreenWindow release ];
    }

@end // BLAppDelegate

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