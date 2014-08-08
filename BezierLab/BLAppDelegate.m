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

#if 0
//    NSLog( @"Volatile Domain Names: %@", [ USER_DEFAULTS volatileDomainNames ] );
//    NSLog( @"Preferences in NSRegistrationDoamin: %@", [ USER_DEFAULTS volatileDomainForName: NSRegistrationDomain ] );

    NSString* string = @"Fucking";
    [ USER_DEFAULTS setObject: string forKey: @"AHAHAH" ];
    [ USER_DEFAULTS setObject: string forKey: @"Numbers" ];

    NSMutableDictionary* preferencesInArgumentDomain = [ [ USER_DEFAULTS volatileDomainForName: NSArgumentDomain ] mutableCopy ];
    [ preferencesInArgumentDomain addEntriesFromDictionary: @{ @"Numbers" : @"U.S.A" } ];
    [ USER_DEFAULTS setVolatileDomain: preferencesInArgumentDomain forName: NSArgumentDomain ];

    [ USER_DEFAULTS removeVolatileDomainForName: NSArgumentDomain ];

    NSLog( @"Preferences in NSArgumentDomain: %@", [ USER_DEFAULTS volatileDomainForName: NSArgumentDomain ] );

    NSLog( @"%@", [ USER_DEFAULTS objectForKey: @"AHAHAH" ] );
    NSLog( @"%@", [ USER_DEFAULTS objectForKey: @"Numbers" ] );
#endif
    }

- ( IBAction ) printPreferencesInTheStandardAppDomain: ( id )_Sender
    {
    NSLog( @"Preferences In Standard App Domain: %@", [ USER_DEFAULTS dictionaryRepresentation ] );
    }

- ( IBAction ) testingForSynchronizing: ( id )_Sender
    {
    NSLog( @"Value for Key AHAHAH: %@", [ USER_DEFAULTS objectForKey: @"AHAHAH" ] );
    }

- ( IBAction ) testingForInsertingSuiteName_PrintValue: ( id )_Sender
    {
    NSLog( @"Value for Key Numbers for BezierLab.app: %@", [ USER_DEFAULTS objectForKey: @"AHAHAH" ] );
    NSLog( @"Value for Key Numbers for LoadImages.app: %@", [ USER_DEFAULTS objectForKey: @"Numbers" ] );
    }

- ( IBAction ) testingForInsertingSuiteName_InsertSuiteName: ( id )_Sender
    {
    [ USER_DEFAULTS addSuiteNamed: @"individual.Tong-G.LoadImages" ];
    }

- ( IBAction ) testingForInsertingSuiteName_RemoveSuiteName: ( id )_Sender
    {
    [ USER_DEFAULTS removeSuiteNamed: @"individual.Tong-G.LoadImages" ];
    }

- ( IBAction ) insertValueToLoadImages: ( id )_Sender
    {
    [ USER_DEFAULTS setObject: @"BLAppDelegate" forKey: @"Numbers" ];
    [ USER_DEFAULTS synchronize ];
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