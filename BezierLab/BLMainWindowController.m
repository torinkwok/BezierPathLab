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

#import "BLMainWindowController.h"

// BLMainWindowController class
@implementation BLMainWindowController

#pragma mark Initializers
+ ( id ) mainWindowController
    {
    return [ [ [ [ self class ] alloc ] init ] autorelease ];
    }

- ( id ) init
    {
    if ( self = [ super initWithWindowNibName: @"BLMainWindow" ] )
        {
        // TODO:
        }

    return self;
    }

#pragma mark Conforms <NSNibAwaking> protocol
- ( void ) awakeFromNib
    {
    [ [ self window ] setFrameUsingName: @"FuckingTongG" force: NO ];
    [ [ self window ] setMiniwindowTitle: @"FUCKING" ];
    [ [ self window ] setCollectionBehavior: NSWindowCollectionBehaviorFullScreenPrimary ];

//    [ self.window setOpaque: NO ];
    [ self.window setAlphaValue: .7 ];
//    [ self.window setBackgroundColor: [ NSColor blackColor ] ];
    [ self.window setBackgroundColor: [ [ NSColor blackColor ] colorWithAlphaComponent: .5 ] ];
    }

- ( void ) windowWillClose: ( NSNotification* )_Notif
    {
    [ [ self window ] saveFrameUsingName: @"FuckingTongG" ];
    }

- ( void ) windowWillMiniaturize: ( NSNotification* )_Notif
    {
    [ NSTimer scheduledTimerWithTimeInterval: 2.f
                                      target: self
                                    selector: @selector( changeTheMiniwindowTitle: )
                                    userInfo: nil
                                     repeats: YES ];
    }

- ( void ) changeTheMiniwindowTitle: ( NSTimer* )_Timer
    {
    int static count;

    if ( count > 20 )
        [ _Timer invalidate ];

    [ self.window setMiniwindowTitle: [ NSString stringWithFormat: @"%d", count ] ];

    count++;
    }

- ( IBAction ) disableWindowButton: ( id )_Sender
    {
    NSButton* closeButton = [ self.window standardWindowButton: NSWindowCloseButton ];
    [ closeButton setEnabled: NO ];
    NSButton* miniButton = [ self.window standardWindowButton: NSWindowMiniaturizeButton ];
    NSButton* zoomButton = [ self.window standardWindowButton: NSWindowZoomButton ];
    NSButton* toolbarButton = [ self.window standardWindowButton: NSWindowToolbarButton ];
    NSButton* documentIconButton = [ self.window standardWindowButton: NSWindowDocumentIconButton ];
    NSButton* documentVersionButton = [ self.window standardWindowButton: NSWindowDocumentVersionsButton ];
    NSButton* fullScreenButton = [ self.window standardWindowButton: NSFullScreenWindowMask ];

    NSLog( @"Close Button: %@", closeButton );
    NSLog( @"Mini Button: %@", miniButton );
    NSLog( @"Zoom Button: %@", zoomButton );
    NSLog( @"Toolbar Button: %@", toolbarButton );
    NSLog( @"Document Icon Button: %@", documentIconButton );
    NSLog( @"Document Version Button: %@", documentVersionButton );
    NSLog( @"Full Screen Button: %@", fullScreenButton );
    }

@end // BLMainWindowController

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