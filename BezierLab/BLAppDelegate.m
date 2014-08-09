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
#import "BLDashboardView.h"

// BLAppDelegate class
@implementation BLAppDelegate
    {
    NSWindow* _mainWindow;
    }

@synthesize _mainWindowController;
@synthesize _getKeyEquivalentMenuItem;

#pragma mark -
#pragma mark Conforms <NSNibLoading> protocol
- ( void ) awakeFromNib
    {
    self._mainWindowController = [ BLMainWindowController mainWindowController ];

    _mainWindow = [ [ self._mainWindowController window ] retain ];

    [ self._mainWindowController showWindow: self ];
    [ self._getKeyEquivalentMenuItem setKeyEquivalent: [ USER_DEFAULTS stringForKey: BLUserDefaultsKeyKeyEquivalent ] ];
    [ self._getKeyEquivalentMenuItem setKeyEquivalentModifierMask: ( NSUInteger )[ USER_DEFAULTS integerForKey: BLUserDefaultsKeyKeyEquivalentModifier ] ];
    }

- ( void ) dealloc
    {
    [ _mainWindow release ];
    _mainWindow = nil;

    [ super dealloc ];
    }

- ( IBAction ) enableAutoenablestems: ( NSMenuItem* )_Sender
    {
    [ [ [ NSApp mainMenu ] itemArray ] enumerateObjectsUsingBlock:
        ^( NSMenuItem* _MenuItem, NSUInteger _Index, BOOL* _Stop )
            {
            [ [ _MenuItem submenu ] setAutoenablesItems: YES ];
            } ];

    [ _Sender setTitle: NSLocalizedString( @"Disable Auto Enabling Items", nil ) ];
    [ _Sender setAction: @selector( disableAutoenablesItems: ) ];
    }

- ( IBAction ) disableAutoenablesItems: ( NSMenuItem* )_Sender
    {
    [ [ [ NSApp mainMenu ] itemArray ] enumerateObjectsUsingBlock:
        ^( NSMenuItem* _MenuItem, NSUInteger _Index, BOOL* _Stop )
            {
            [ [ _MenuItem submenu ] setAutoenablesItems: NO ];
            } ];

    [ _Sender setTitle: NSLocalizedString( @"Enable Auto Enabling Items", nil ) ];
    [ _Sender setAction: @selector( enableAutoenablestems: ) ];
    }

- ( IBAction ) removeCurrentMenu: ( NSMenuItem* )_Sender
    {
    NSMenu* mainMenu = [ NSApp mainMenu ];
    [ mainMenu removeItemAtIndex: [ mainMenu indexOfItemWithSubmenu: _Sender.menu ] ];
    }

- ( IBAction ) keyEquivalent: ( id )_Sender
    {
    NSLog( @"%@", [ _getKeyEquivalentMenuItem keyEquivalent ] );
    [ USER_DEFAULTS setInteger: NSCommandKeyMask | NSShiftKeyMask forKey: BLUserDefaultsKeyKeyEquivalentModifier ];
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