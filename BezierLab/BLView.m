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

#import "BLView.h"
#import "BLCompressionSchemesViewController.h"

// Notification names
NSString* const BLViewClickedButtonNotification = @"Clicked Button Notif";

// Error domain
NSString* const BLBezierLabErrorDomain = @"individual.TongG.BezierLab.ErrorDomain";

    // Error code
    NSInteger const BLFailureToCreateImageError = 0x31;

// BLView class
@implementation BLView

@synthesize _XMLDocument;

- ( void ) awakeFromNib
    {
    self._flipTransform = [ NSAffineTransform transform ];

    [ NOTIFICATION_CENTER addObserver: self
                             selector: @selector( testingForImageRep: )
                                 name: @"TestingForImageRep"
                               object: nil ];

    [ NOTIFICATION_CENTER addObserver: self
                             selector: @selector( testingForErrorHandlingOfParsingXMLDocument: )
                                 name: @"TestingForErrorHandling"
                               object: nil ];
    }

- ( BOOL ) isFlipped
    {
    return YES;
    }

#pragma mark Testings for NSImage, NSImageRep along with its subclass
- ( void ) testingForImageRep: ( NSNotification* )_Notif
    {
    NSOpenPanel* openPanel = [ NSOpenPanel openPanel ];

    NSMenuItem* senderMenuItem = [ _Notif userInfo ][ BLViewClickedButtonNotification ];
    BOOL isTestingForNSImageRep = [ senderMenuItem.title isEqualToString: NSLocalizedString( @"Testing for NSImageRep", nil ) ];
    if ( isTestingForNSImageRep )
        [ openPanel setMessage: NSLocalizedString( @"Testing for NSImageRep", nil ) ];
    else
        [ openPanel setMessage: NSLocalizedString( @"Testing for Fucking NSImage", nil ) ];

    [ openPanel setPrompt: NSLocalizedString( @"Choose", nil ) ];
    [ openPanel setAllowedFileTypes: [ NSImage imageUnfilteredFileTypes ] ];

    [ openPanel beginSheetModalForWindow: [ self window ]
                       completionHandler:
        ^( NSInteger _Result )
            {
            if ( _Result == NSFileHandlingPanelOKButton )
                {
                dispatch_queue_t defaultGlobalDispatchQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 );

                dispatch_async( defaultGlobalDispatchQueue
                    , ^( void )
                        {
                        if ( isTestingForNSImageRep )
                            {
                            NSArray* bitmapImageReps = [ NSBitmapImageRep imageRepsWithContentsOfURL: [ openPanel URL ] ];

                            dispatch_apply( [ bitmapImageReps count ], defaultGlobalDispatchQueue
                                , ^( size_t _CurrentIndex )
                                    {
                                    [ self lockFocusIfCanDraw ];
                                    [ self flipCurrentTransform ];

                                    srand( ( int )time( NULL ) );
                                    NSRect rect = NSMakeRect( random() % ( long )self.bounds.size.width
                                                            , random() % ( long )self.bounds.size.height
                                                            , 100, 100 ) ;

                                    NSBitmapImageRep* imageRep = ( NSBitmapImageRep* )bitmapImageReps[ _CurrentIndex ];
                                    NSImage* image = [ [ NSImage alloc ] init ];
                                    [ image drawRepresentation: imageRep inRect: rect ];
//                                    [ imageRep drawInRect: rect fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1.f respectFlipped: NO hints: nil ];
                                    [ image release ];

                                    [ [ NSGraphicsContext currentContext ] flushGraphics ];

                                    [ self undoFlip ];
                                    [ self unlockFocus ];
                                    } );
                            }
                        else
                            {
                            [ self lockFocusIfCanDraw ];

                            NSImage* sourceImage = [ [ [ NSImage alloc ] initWithContentsOfURL: [ openPanel URL ] ] autorelease ];

                            NSURL* destImageURL = [ NSURL URLWithString: @"file:///sers/EsquireTongG/QingFeng.png" ];
                            NSImage* destinationImage = [ [ [ NSImage alloc ] initWithContentsOfURL: destImageURL ] autorelease ];
                            if ( !destinationImage )
                                {
                                NSError* failureToCreateDestImage = [ NSError errorWithDomain: BLBezierLabErrorDomain
                                                                                         code: BLFailureToCreateImageError
                                                                                     userInfo:
                                    @{ NSLocalizedDescriptionKey : [ NSString stringWithFormat: NSLocalizedString( @"Failure to create the image which located at %@. Because the path is incorrect.", nil ), destImageURL.path ]
                                     , NSFilePathErrorKey: [ destImageURL path ]
                                     , NSLocalizedFailureReasonErrorKey: NSLocalizedString( @"Because the path is incorrect.", nil )
                                     , NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString( @"Choose a correct path and try again?", nil )
                                     , NSLocalizedRecoveryOptionsErrorKey: @[ NSLocalizedString( @"Try again",nil ), NSLocalizedString( @"Cancel", nil ) ]
                                     , NSRecoveryAttempterErrorKey : self
                                     } ];

                                dispatch_async( dispatch_get_main_queue()
                                    , ^( void )
                                        {
                                        [ self presentError: failureToCreateDestImage ];

//                                        [ self presentError: failureToCreateDestImage
//                                             modalForWindow: [ self window ]
//                                                   delegate: self
//                                         didPresentSelector: @selector( didPresentErrorWithRecovery:contextInfo: )
//                                                contextInfo: nil ];
                                        } );
                                }

//                            [ sourceImage setFlipped: YES ];
//                            [ destinationImage setFlipped: YES ];

//                            [ translateTransformation rotateByDegrees: 20.f ];
//                            [ self flipCurrentTransform ];
//                            [ translateTransformation concat ];

//                            [ sourceImage drawAtPoint: NSMakePoint( 50, 50 )
//                                             fromRect: NSZeroRect
//                                            operation: NSCompositeSourceOver
//                                             fraction: 1.f ];

                            NSAffineTransformStruct transformStruct = { .5f, 0.f, 0.f, .5f, 0.f, 0.f };
                            NSAffineTransform* transform = [ NSAffineTransform transform ];
                            [ transform setTransformStruct: transformStruct ];
                            [ transform concat ];

                            [ sourceImage drawInRect: NSMakeRect( 300, 300, 200, 200 ) ];
                            [ sourceImage drawInRect: NSMakeRect( 50, 50, 200, 200 )
                                            fromRect: NSMakeRect( 100, 300, 200, 200 )
                                           operation: NSCompositeSourceOver
                                            fraction: 1.f ];

                            [ transform invert ];
                            [ transform concat ];

                            NSAffineTransform* translateTransformation = [ NSAffineTransform transform ];
                            NSAffineTransformStruct translateTransformationStruct = { 1.f, 0.f, 0.f, 1.f, 20.f, 20.f };
                            [ translateTransformation setTransformStruct: translateTransformationStruct ];

                            NSPoint point = NSMakePoint( 50, 50 );

                            [ destinationImage drawAtPoint: [ translateTransformation transformPoint: point ]
                                                  fromRect: NSZeroRect
                                                 operation: NSCompositeSourceOver
                                                  fraction: .8f ];

                            [ [ NSGraphicsContext currentContext ] flushGraphics ];

                            [ self unlockFocus ];
                            }
                        } );
                }
            } ];

    }

// Flip transform for removing the inversion caused by the view being flipped.
- ( void ) flipCurrentTransform
    {
    NSAffineTransformStruct flipTransformStruct = { 1.f, .0f, .0f, -1.f, .0f, self.bounds.size.height };
    [ self._flipTransform setTransformStruct: flipTransformStruct ];
    [ self._flipTransform concat ];
    }

// Undo the flip transform.
- ( void ) undoFlip
    {
    [ self._flipTransform invert ];
    [ self._flipTransform concat ];
    }

- ( void ) testingForErrorHandlingOfParsingXMLDocument: ( id )_Sender
    {
    NSError* err = nil;

    // self._XMLDocument is an NSXMLDocument instance variable.
    if ( self._XMLDocument )
        self._XMLDocument = nil;

    NSURL* url = [ NSURL URLWithString: @"file:///Users/EsquireTongG/xml.plis" ];
    self._XMLDocument = [ [ [ NSXMLDocument alloc ] initWithContentsOfURL: url options: NSXMLNodeOptionsNone error: &err ] autorelease ];

    if ( !self._XMLDocument && err )
        {
        NSMutableDictionary* newUserInfo = [ [ err userInfo ] mutableCopy ];
        newUserInfo[ NSURLErrorKey ] = url;

        [ self presentError: [ NSError errorWithDomain: err.domain code: err.code userInfo: newUserInfo ]
             modalForWindow: [ self window ]
                   delegate: self
         didPresentSelector: @selector( didPresentRecoveryWithRecovery:contextInfo: )
                contextInfo: nil ];
        }
    }

- ( void ) attemptRecoveryFromError: ( NSError* )_Error
                        optionIndex: ( NSUInteger )_RecoveryOptionIndex
                           delegate: ( id )_Delegate
                 didRecoverSelector: ( SEL )_DidRecoverSelector
                        contextInfo: ( void* )_ContextInfo
    {
    BOOL success = NO;
    NSError* err = nil;

    NSInvocation* invocation = [ NSInvocation invocationWithMethodSignature: [ _Delegate methodSignatureForSelector: _DidRecoverSelector ] ];
    [ invocation setSelector: _DidRecoverSelector ];

    if ( _RecoveryOptionIndex == 0 )    // Recovery requested.
        {
        self._XMLDocument = [ [ [ NSXMLDocument alloc ] initWithContentsOfURL: _Error.userInfo[ NSURLErrorKey ]
                                                                      options: NSXMLDocumentTidyXML
                                                                        error: &err ] autorelease ];
        if ( self._XMLDocument )
            success = YES;
        }

    [ invocation setArgument: ( void* )&success atIndex: 2 ];

    if ( err )
        [ invocation setArgument: &err atIndex: 3 ];

    [ invocation invokeWithTarget: _Delegate ];
    }

- ( void ) didPresentRecoveryWithRecovery: ( BOOL )_DidRecover
                              contextInfo: ( void* )_ContextInfo
    {
    NSError* error = ( NSError* )_ContextInfo;

    if ( error && [ error isKindOfClass: [ NSError class ] ] )
        {
        [ [ NSAlert alertWithError: error ] beginSheetModalForWindow: [ self window ]
                                                   completionHandler: nil ];
        }
    }

- ( NSError* ) willPresentError: ( NSError* ) _Error
    {
    if ( [ [ _Error domain ] isEqualToString: NSCocoaErrorDomain ] )
        {
        switch ( [ _Error code ] )
            {
        case NSFileReadNoSuchFileError:
                {
                NSString* newDesc = [ [ _Error localizedDescription ]
                    stringByAppendingString: ( _Error.localizedFailureReason ? _Error.localizedFailureReason : @"" ) ];

                NSMutableDictionary* newUserInfo = [ [ _Error userInfo ] mutableCopy ];

                newUserInfo[ NSLocalizedDescriptionKey ] = newDesc;
                newUserInfo[ NSLocalizedRecoverySuggestionErrorKey ] = NSLocalizedString( @"Would you like to tidy the XML and try again?", nil );
                newUserInfo[ NSLocalizedRecoveryOptionsErrorKey ] = @[ NSLocalizedString( @"Yeah, try again", nil ), NSLocalizedString( @"Cancel", nil ) ];
                newUserInfo[ NSRecoveryAttempterErrorKey ] = self;

                NSError* customizedError = [ NSError errorWithDomain: [ _Error domain ]
                                                                code: [ _Error code ]
                                                            userInfo: newUserInfo ];
                return customizedError;
                }
        default:
                return [ super willPresentError: _Error ];
            }
        }

    return [ super willPresentError: _Error ];
    }

@end // BLView

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