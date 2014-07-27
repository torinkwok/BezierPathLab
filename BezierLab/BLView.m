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
    [ openPanel setAllowedFileTypes: [ NSImage imageUnfilteredTypes ] ];

    [ openPanel beginSheetModalForWindow: [ self window ]
                       completionHandler:
        ^( NSInteger _Result )
            {
            if ( _Result == NSFileHandlingPanelOKButton )
                {
                NSURL* selectedURL = [ openPanel URL ];

                dispatch_queue_t defaultGlobalDispatchQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 );

                dispatch_async( defaultGlobalDispatchQueue
                    , ^( void )
                        {
                        if ( isTestingForNSImageRep )
                            {
                            NSArray* bitmapImageReps = [ NSBitmapImageRep imageRepsWithContentsOfURL: selectedURL ];

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

                                    [ imageRep drawInRect: rect fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1.f respectFlipped: NO hints: nil ];
                                    [ image release ];

                                    [ [ NSGraphicsContext currentContext ] flushGraphics ];

                                    [ self undoFlip ];
                                    [ self unlockFocus ];
                                    } );
                            }
                        else
                            {
                            [ self lockFocusIfCanDraw ];

                            NSImage* sourceImage = [ [ [ NSImage alloc ] initWithContentsOfURL: selectedURL ] autorelease ];
                            [ sourceImage setName: @"QingFeng" ];
                            [ sourceImage setName: nil ];

//                            NSURL* destImageURL = [ [ NSBundle mainBundle ] URLForResource: @"QingFeng" withExtension: @"png" ];
                            NSImage* destinationImage = [ NSImage imageNamed: @"QingFeng" ];

//                            if ( destImageURL )
//                                destinationImage = [ [ [ NSImage alloc ] initWithContentsOfURL: destImageURL ] autorelease ];
//                            else
//                                destImageURL = [ [ NSBundle mainBundle ] bundleURL ];

                            if ( destinationImage )
                                {
                                NSAffineTransform* translateTransformation = [ NSAffineTransform transform ];
                                NSAffineTransformStruct translateTransformationStruct = { 1.f, 0.f, 0.f, 1.f, 20.f, 20.f };
                                [ translateTransformation setTransformStruct: translateTransformationStruct ];

                                NSPoint point = NSMakePoint( 50, 50 );

                                [ self drawOnImage: destinationImage ];
                                [ destinationImage drawAtPoint: [ translateTransformation transformPoint: point ]
                                                      fromRect: NSZeroRect
                                                     operation: NSCompositeSourceOver
                                                      fraction: .8f ];
                                }
                            else
                                {
                                NSError* failureToCreateDestImage = [ NSError errorWithDomain: BLBezierLabErrorDomain
                                                                                         code: BLFailureToCreateImageError
                                                                                     userInfo: nil ];
                                dispatch_async( dispatch_get_main_queue()
                                    , ^( void )
                                        {
                                        [ self presentError: failureToCreateDestImage
                                             modalForWindow: [ self window ]
                                                   delegate: self
                                         didPresentSelector: @selector( didPresentErrorWithRecovery:contextInfo: )
                                                contextInfo: nil ];
                                        } );
                                }

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

                            [ [ NSGraphicsContext currentContext ] flushGraphics ];

                            [ self unlockFocus ];
                            }
                        } );
                }
            } ];

    }

- ( void ) drawOnImage: ( NSImage* )_Image
    {
    NSImage* image = [ NSImage imageWithSize: NSMakeSize( 100, 100 )
                                     flipped: NO
                              drawingHandler:
                         ^BOOL ( NSRect _Rect )
                             {
                             NSColor* strokeColor = [ NSColor colorWithCalibratedRed: .6392f green: .5333 blue: .8588 alpha: 1.f ];
                             NSColor* fillColor = [ NSColor colorWithDeviceCyan: .5042 magenta: .0f yellow: .2362 black: .0f alpha: 1.f ];
                             [ strokeColor setStroke ];
                             [ fillColor setFill ];

                             NSBezierPath* bezierPath = [ NSBezierPath bezierPathWithOvalInRect: NSMakeRect( 20, 0, 100, 100 ) ];
                             [ bezierPath setLineWidth: 10 ];
                             [ bezierPath stroke ];
                             [ bezierPath fill ];

                             return YES;
                             } ];

    // NSImage 0x60800007e740
    // NSCustomImageRep 0x60800009e230
    [ image drawInRect: NSMakeRect( 300, 300, 100, 100 )
              fromRect: NSMakeRect( 0, 0, 50, 50 )
             operation: NSCompositeSourceOver
              fraction: 1.f ];

    [ self flipCurrentTransform ];

    [ image drawInRect: NSMakeRect( 200, 200, 101, 100 )
              fromRect: NSMakeRect( 20, 30, 50, 50 )
             operation: NSCompositeSourceOver
              fraction: 1.f ];

    [ self undoFlip ];
#if 0
    [ _Image lockFocus ];

    [ _Image unlockFocus ];
#endif
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

- ( void ) attemptRecoveryFromError: ( NSError* )_Error
                        optionIndex: ( NSUInteger )_OptionIndex
                           delegate: ( id )_Delegate
                 didRecoverSelector: ( SEL )_DidRecoverySelector
                        contextInfo: ( void* )_ContextInfo
    {
    __block BOOL isRecoverSuccess = NO;

    NSInvocation* invocation = [ NSInvocation invocationWithMethodSignature: [ _Delegate methodSignatureForSelector: _DidRecoverySelector ] ];
    [ invocation setSelector: _DidRecoverySelector ];

    if ( [ _Error.domain isEqualToString: BLBezierLabErrorDomain ] )
        {
        switch ( [ _Error code ] )
            {
        case BLFailureToCreateImageError:
                {
                if ( _OptionIndex == 0 )
                    {
                    NSOpenPanel* openPanel = [ NSOpenPanel openPanel ];

                    [ openPanel setPrompt: NSLocalizedString( @"Choose", nil ) ];
                    [ openPanel setMessage: NSLocalizedString( @"Choose a correct path again.", nil ) ];
                    [ openPanel setCanChooseDirectories: NO ];
                    [ openPanel setAllowedFileTypes: [ NSImage imageUnfilteredFileTypes ] ];

                    [ openPanel beginSheetModalForWindow: [ self window ]
                                       completionHandler:
                        ^( NSInteger _Result )
                            {
                            if ( _Result == NSFileHandlingPanelOKButton )
                                {
                                NSURL* correctURL = [ openPanel URL ];
                                isRecoverSuccess = YES;

                                [ invocation setArgument: ( void* )&isRecoverSuccess atIndex: 2 ];

                                [ invocation setArgument: &correctURL atIndex: 3 ];
                                [ invocation invokeWithTarget: _Delegate ];
                                }
                            } ];
                    return;
                    }
                }
            }
        }

    [ invocation setArgument: ( void* )&isRecoverSuccess atIndex: 2 ];
    [ invocation invokeWithTarget: _Delegate ];
    }

- ( void ) didPresentErrorWithRecovery: ( BOOL )_DidRecover
                           contextInfo: ( id )_ContextInfo
    {
    if ( _DidRecover && [ _ContextInfo isKindOfClass: [ NSURL class ] ] )
        {
        NSURL* correctURL = ( NSURL* )_ContextInfo;
        NSImage* imageWithCorrectPath = [ [ [ NSImage alloc ] initWithContentsOfURL: correctURL ] autorelease ];

        NSAffineTransform* translateTransformation = [ NSAffineTransform transform ];
        NSAffineTransformStruct translateTransformationStruct = { 1.f, 0.f, 0.f, 1.f, 20.f, 20.f };
        [ translateTransformation setTransformStruct: translateTransformationStruct ];

        NSPoint point = NSMakePoint( 50, 50 );

        [ imageWithCorrectPath drawAtPoint: [ translateTransformation transformPoint: point ]
                              fromRect: NSZeroRect
                             operation: NSCompositeSourceOver
                              fraction: .8f ];
        }
    }

- ( NSError* ) willPresentError: ( NSError* )_Error
    {
    if ( [ _Error.domain isEqualToString: BLBezierLabErrorDomain ] )
        {
        switch ( [ _Error code ] )
            {
        case BLFailureToCreateImageError:
                {
                NSMutableDictionary* newInfo = [ [ _Error userInfo ] mutableCopy ];

                newInfo[ NSLocalizedDescriptionKey ] = [ NSString stringWithFormat: NSLocalizedString( @"Failure to create the image which located at %@. Because the path is incorrect.", nil ), newInfo[ NSFilePathErrorKey ] ];
                newInfo[ NSLocalizedFailureReasonErrorKey ] = NSLocalizedString( @"Because the path is incorrect.", nil );
                newInfo[ NSLocalizedRecoverySuggestionErrorKey ] = NSLocalizedString( @"Choose a correct path and try again?", nil );
                newInfo[ NSLocalizedRecoveryOptionsErrorKey ] = @[ NSLocalizedString( @"Try again",nil ), NSLocalizedString( @"Cancel", nil ) ];
                newInfo[ NSRecoveryAttempterErrorKey ] = self;

                return [ NSError errorWithDomain: _Error.domain code: _Error.code userInfo: newInfo ];
                }
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