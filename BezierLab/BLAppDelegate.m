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
- ( IBAction ) testingForImageRef: ( id )_Sender
    {
    NSOpenPanel* openPanel = [ NSOpenPanel openPanel ];

    [ openPanel beginSheetModalForWindow: [ self._mainWindowController window ]
                       completionHandler:
        ^( NSInteger _Result )
            {
            if ( _Result == NSFileHandlingPanelOKButton )
                {
                NSArray* imageReps = [ NSPDFImageRep imageRepsWithContentsOfURL: [ openPanel URL ] ];

                NSLog( @"ImageReps: %@", imageReps );
                }
            } ];

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