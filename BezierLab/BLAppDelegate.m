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
#import "BLSlider.h"
#import "BLModalWindowController.h"
#import "BLTestingWindowController.h"

// BLAppDelegate class
@implementation BLAppDelegate
    {
    NSWindow* _mainWindow;
    NSWindow* _testingWindow;
    }

@synthesize _mainWindowController;

#pragma mark -
#pragma mark Conforms <NSNibLoading> protocol
- ( void ) awakeFromNib
    {
    self._mainWindowController = [ BLMainWindowController mainWindowController ];
    self._testingWindowController = [ BLTestingWindowController testingWindowController ];

    _mainWindow = [ [ self._mainWindowController window ] retain ];
    _testingWindow = [ [ self._testingWindowController window ] retain ];

    [ self._mainWindowController showWindow: self ];
    [ self._testingWindowController showWindow: self ];
    }

- ( void ) dealloc
    {
    [ _mainWindow release ];
    _mainWindow = nil;

    [ _testingWindow release ];
    _testingWindow = nil;

    [ super dealloc ];
    }

- ( void ) applicationDidFinishLaunching: ( NSNotification* )_Notification
    {
    BLSlider* slider = [ [ BLSlider alloc ] initWithFrame: NSMakeRect( 20, 44, 115, 25 ) ];
    [ slider setTarget: self ];
    [ slider setAction: @selector( fuckingSlider ) ];

    [ self._mainWindowController.window.contentView addSubview: slider ];
    }

- ( void ) fuckingSlider
    {
    __CAVEMEN_DEBUGGING__PRINT_WHICH_METHOD_INVOKED__;
    }

- ( IBAction ) creatingAWindow: ( id )_Sender
    {
    NSRect contentRect = NSMakeRect( 400, 200, 400, 400 );
    NSWindow* window = [ [ NSWindow alloc ] initWithContentRect: contentRect
                                                        styleMask: NSTitledWindowMask | NSClosableWindowMask
                                                          backing: NSBackingStoreBuffered
                                                            defer: NO ];
//    [ window display ];
    [ window orderFront: self ];
    }

- ( IBAction ) printingWindow: ( id )_Sender
    {
    NSRect frame = _mainWindow.frame;
    NSLog( @"%@", NSStringFromRect( _mainWindow.frame ) );
    NSData* PDFData = [ _mainWindow dataWithPDFInsideRect: NSMakeRect( 0, 0, frame.size.width, frame.size.height ) ];

    NSSavePanel* savePanel = [ NSSavePanel savePanel ];

    [ savePanel beginSheetModalForWindow: _mainWindow
                       completionHandler:
        ^( NSInteger _Result )
            {
            [ PDFData writeToURL: [ savePanel URL ] atomically: YES ];
            } ];
    }

- ( IBAction ) displayWindow: ( id )_Sender
    {
    [ _mainWindow displayIfNeeded ];
    }

- ( IBAction ) updateWindow: ( id )_Sender
    {
    [ _mainWindow update ];
    }

- ( IBAction ) stopModal: ( id )_Sender
    {
    [ NSApp stopModal ];
    }

- ( IBAction ) displayModalWindow: ( id )_Sender
    {
    BLModalWindowController* modalWindowController = [ BLModalWindowController modalWindowController ];
    NSWindow* modalWindow = [ modalWindowController window ];

    NSModalResponse modalResponse = [ NSApp runModalForWindow: modalWindow ];

    NSLog( @"Modal Response: %ld", modalResponse );
    switch ( modalResponse )
        {
    case NSModalResponseStop:
        NSLog( @"Stop" );   break;

    case NSModalResponseAbort:
        NSLog( @"Abort" );  break;
        }
    }

- ( IBAction ) showPanel: ( id )_Sender
    {
    [ NOTIFICATION_CENTER postNotificationName: @"showPanel:"
                                        object: nil
                                      userInfo: nil ];
    }

- ( IBAction ) closeWindow: ( id )_Sender
    {
    [ _mainWindow close ];
    }

- ( IBAction ) createATestingWindow: ( id )_Sender
    {
    NSWindow* newWindow = [ [ [ NSWindow alloc ] initWithContentRect: NSMakeRect( 500, 200, 300, 300 )
                                                           styleMask: NSClosableWindowMask | NSTitledWindowMask
                                                             backing: NSBackingStoreBuffered
                                                               defer: NO ] autorelease ];

    NSLog( @"Can become key window: %@", [ newWindow canBecomeKeyWindow ] ? @"YES" : @"NO" );
    }

- ( IBAction ) orderWindowRelativeTo: ( id )_Sender
    {
    [ NOTIFICATION_CENTER postNotificationName: @"orderWindowRelativeTo:"
                                        object: nil
                                      userInfo: nil ];
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