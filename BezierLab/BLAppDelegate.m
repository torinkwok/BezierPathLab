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

NSInteger const BLInvalidFileTypeError = 33;

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

- ( IBAction ) testingForPDFRep: ( id )_Sender
    {
    NSWindow* mainWindow = [ self._mainWindowController window ];
    NSView* contentView = [ mainWindow contentView ];

    NSData* PDFDataForContentView = [ mainWindow dataWithPDFInsideRect: [ contentView visibleRect ] ];
    NSPDFImageRep* PDFImageRep = [ [ [ NSPDFImageRep alloc ] initWithData: PDFDataForContentView ] autorelease ];
    NSImage* image = [ [ [ NSImage alloc ] init ] autorelease ];
    [ image addRepresentation: PDFImageRep ];

    NSLog( @"%@ drawing to screen #1: %@"
         , [ NSGraphicsContext currentContext ]
         , [ [ NSGraphicsContext currentContext ] isDrawingToScreen ] ? @"YES" : @"NO"
         );

    [ image lockFocus ];
    NSLog( @"%@ drawing to screen #2: %@"
         , [ NSGraphicsContext currentContext ]
         , [ [ NSGraphicsContext currentContext ] isDrawingToScreen ] ? @"YES" : @"NO"
         );
    [ image unlockFocus ];
    }

- ( IBAction ) testingForConvertingBitmap: ( id )_Sender
    {
    NSWindow* mainWindow = [ self._mainWindowController window ];
    NSView* contentView = [ mainWindow contentView ];

    NSOpenPanel* openPanel = [ NSOpenPanel openPanel ];

    [ openPanel setCanChooseDirectories: NO ];
    [ openPanel setAllowsMultipleSelection: YES ];

    [ openPanel beginSheetModalForWindow: mainWindow
                       completionHandler:
        ^( NSInteger _Result )
            {
            if ( _Result == NSFileHandlingPanelOKButton )
                {
                NSArray* supportedTypes = [ NSImage imageUnfilteredTypes ];

                NSArray* URLs = [ openPanel URLs ];
                NSMutableArray* imageReps = [ NSMutableArray array ];

                NSURL* nextURL = nil;
                NSString* UTIForURL = nil;

                NSEnumerator* URLsEnum = [ URLs objectEnumerator ];
                while ( nextURL = [ URLsEnum nextObject ] )
                    {
                    [ nextURL getResourceValue: &UTIForURL forKey: NSURLTypeIdentifierKey error: nil ];

                    BOOL isNoProblem = NO;
                    for ( NSString* UTI in supportedTypes )
                        {
                        if ( UTTypeConformsTo( ( __bridge CFStringRef )UTIForURL, ( __bridge CFStringRef )UTI ) )
                            {
                            isNoProblem = YES;
                            break;
                            }
                        }

                    if ( !isNoProblem )
                        {
                        [ openPanel orderOut: nil ];

                        NSError* error = [ NSError errorWithDomain: BLBezierLabErrorDomain code: BLInvalidFileTypeError userInfo: nil ];
                        [ contentView presentError: error
                                    modalForWindow: mainWindow
                                          delegate: self
                                didPresentSelector: @selector( didPresentErrorRecovery:contextInfo: )
                                       contextInfo: nil ];
                        return;
                        }

                    [ imageReps addObjectsFromArray: [ NSBitmapImageRep imageRepsWithContentsOfURL: nextURL ] ];
                    }

                [ openPanel orderOut: nil ];

                NSSavePanel* savePanel = [ NSSavePanel savePanel ];
                [ savePanel beginSheetModalForWindow: mainWindow
                                   completionHandler:
                    ^( NSInteger _Result )
                        {
                        if ( _Result == NSFileHandlingPanelOKButton )
                            {
                            NSData* TIFFRep = [ NSBitmapImageRep TIFFRepresentationOfImageRepsInArray: imageReps ];
                            [ TIFFRep writeToURL: [ savePanel URL ] atomically: YES ];
                            }
                        } ];
                }
            } ];
    }

- ( void ) attemptRecoveryFromError: ( NSError* )_Error
                        optionIndex: ( NSUInteger )_OptionsIndex
                           delegate: ( id )_Delegate
                 didRecoverSelector: ( SEL )_Selector
                        contextInfo: ( void* )_ContextInfo
    {

    }

- ( void ) didPresentErrorRecovery: ( BOOL )_DidRecovery
                       contextInfo: ( id )_ContextInfo
    {

    }

- ( NSError* ) application: ( NSApplication* )_App
          willPresentError: ( NSError* )_Error
    {
    NSMutableDictionary* newUserInfo = [ [ _Error userInfo ] mutableCopy ];

    if ( [ _Error.domain isEqualToString: BLBezierLabErrorDomain ] )
        {
        switch ( [ _Error code ] )
            {
        case BLInvalidFileTypeError:
                {
                newUserInfo[ NSLocalizedDescriptionKey ] = NSLocalizedString( @"The file type is invalid. It's not a bitmap image.", nil );
                newUserInfo[ NSLocalizedFailureReasonErrorKey ] = NSLocalizedString( @"It's not a bitmap image.", nil );
                newUserInfo[ NSLocalizedRecoverySuggestionErrorKey ] = NSLocalizedString( @"Choose the valid file and try again?", nil );
                newUserInfo[ NSLocalizedRecoveryOptionsErrorKey ] = @[ NSLocalizedString( @"Try Again", nil ), NSLocalizedString( @"Cancel", nil ) ];
                newUserInfo[ NSRecoveryAttempterErrorKey ] = self;
                } break;
            }
        }

    return [ NSError errorWithDomain: _Error.domain code: _Error.code userInfo: newUserInfo ];
    }

- ( IBAction ) testingForNSScreen: ( id )_Sender
    {
    NSLog( @"Device Description: %@", [ [ NSScreen mainScreen ] deviceDescription ] );

    NSWindow* mainWindow = [ self._mainWindowController window ];
    NSView* contentView = [ mainWindow contentView ];
    [ contentView displayIfNeeded ];
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