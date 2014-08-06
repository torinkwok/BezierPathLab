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

// BLAppDelegate class
@implementation BLAppDelegate
    {
    NSWindow* _mainWindow;
    }

@synthesize _mainWindowController;

#pragma mark -
#pragma mark Conforms <NSNibLoading> protocol
- ( void ) awakeFromNib
    {
    self._mainWindowController = [ BLMainWindowController mainWindowController ];

    _mainWindow = [ [ self._mainWindowController window ] retain ];

    [ self._mainWindowController showWindow: self ];
    }

- ( void ) dealloc
    {
    [ _mainWindow release ];
    _mainWindow = nil;

    [ super dealloc ];
    }

- ( void ) applicationDidFinishLaunching: ( NSNotification* )_Notification
    {

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
    [ _mainWindow display ];
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