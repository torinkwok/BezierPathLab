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
#import "BLTestingViewController.h"

// Notification names
NSString* const BLViewClickedButtonNotification = @"Clicked Button Notif";

// Error domain
NSString* const BLBezierLabErrorDomain = @"individual.TongG.BezierLab.ErrorDomain";

    // Error code
    NSInteger const BLFailureToCreateImageError = 31;
    NSInteger const BLFailureToDrawnIntoViewError = 32;

// BLView class
@implementation BLView

@synthesize _XMLDocument;
@synthesize _flipTransform;
@synthesize _testingViewController;

@synthesize _startCapImage;
@synthesize _centerFillImage;
@synthesize _endCapImage;

- ( void ) awakeFromNib
    {
    self._flipTransform = [ NSAffineTransform transform ];
    self._testingViewController = [ BLTestingViewController testingViewController ];

    [ NOTIFICATION_CENTER addObserver: self
                             selector: @selector( testingForImageRep: )
                                 name: @"TestingForImageRep"
                               object: nil ];

    [ NOTIFICATION_CENTER addObserver: self
                             selector: @selector( checkToSeeIfAViewCanBeDrawn: )
                                 name: @"TestingForCanBeDrawn"
                               object: nil ];

    self._startCapImage = [ [ [ NSImage alloc ] initWithContentsOfFile: @"/Users/EsquireTongG/_startCap.tiff" ] autorelease ];
    self._centerFillImage = [ [ [ NSImage alloc ] initWithContentsOfFile: @"/Users/EsquireTongG/_centerFill.tiff" ] autorelease ];
    self._endCapImage = [ [ [ NSImage alloc ] initWithContentsOfFile: @"/Users/EsquireTongG/_endCap.tiff" ] autorelease ];
    }

- ( BOOL ) isFlipped
    {
    return YES;
    }

NSRect customButtonFrame;
- ( void ) drawRect: ( NSRect )_Rect
    {
    customButtonFrame = NSMakeRect( 20, 60, 100, 20 );

    if ( [ self lockFocusIfCanDraw ] )
        {
        if ( _startCapImage && _centerFillImage && _endCapImage )
            NSDrawThreePartImage( customButtonFrame
                                , _startCapImage, _centerFillImage, _endCapImage, NO, NSCompositeSourceOver, 1.f, YES );

        // New journey for NSShadow
        NSColor* strokeColor = [ NSColor colorWithCalibratedRed: 0.3843f green: 0.7569 blue: 0.9451 alpha: 1.f ];
        NSColor* fillColor = [ NSColor colorWithCalibratedRed: 0.8784 green: 0.7922 blue: 0.4392 alpha: 1.f ];
        [ strokeColor setStroke ];
        [ fillColor setFill ];

        [ self flipCurrentTransform ];

        [ NSGraphicsContext saveGraphicsState ];

        NSShadow* shadow = [ [ [ NSShadow alloc ] init ] autorelease ];
        [ shadow setShadowColor: [ [ NSColor blackColor ] colorWithAlphaComponent: .3f ] ];
        [ shadow setShadowOffset: NSMakeSize( 10.f, -10.f ) ];
        [ shadow setShadowBlurRadius: 5.f ];

        [ shadow set ];

        // Bezier Path for Oval
        NSBezierPath* bezierPathForOval = [ NSBezierPath bezierPathWithOvalInRect: NSMakeRect( 50, 100, 200, 200 ) ];
        [ bezierPathForOval setLineWidth: 20 ];

        [ bezierPathForOval stroke ];
        [ bezierPathForOval fill ];

        [ NSGraphicsContext restoreGraphicsState ];

        // Bezier Path for Oval
        NSBezierPath* bezierPathForRectangle = [ NSBezierPath bezierPathWithOvalInRect: NSMakeRect( 280, 100, 200, 200 ) ];
        [ bezierPathForRectangle setLineWidth: 20 ];

        [ NSGraphicsContext saveGraphicsState ];
        [ shadow set ];
        [ bezierPathForRectangle stroke ];
        [ NSGraphicsContext restoreGraphicsState ];

        [ bezierPathForRectangle fill ];

        [ self unlockFocus ];
        }
    else
        {
        NSError* error = [ NSError errorWithDomain: BLBezierLabErrorDomain code: BLFailureToDrawnIntoViewError userInfo: nil ];
        [ self presentError: error
             modalForWindow: [ self window ]
                   delegate: self
         didPresentSelector: @selector( didPresentErrorWithRecovery:contextInfo: )
                contextInfo: nil ];
        }
    }

- ( void ) mouseDown: ( NSEvent* )_Event
    {
    NSPoint location = [ self convertPoint: [ _Event locationInWindow ] fromView: nil ];

    if ( NSPointInRect( location , customButtonFrame ) )
        if ( [ self lockFocusIfCanDraw ] )
            {
            NSDrawThreePartImage( customButtonFrame
                                , _startCapImage, _centerFillImage, _endCapImage, NO, NSCompositeSourceOver, 1.f, NO );
            [ [ NSGraphicsContext currentContext ] flushGraphics ];
            [ self unlockFocus ];
            }
    }

- ( void ) mouseUp: ( NSEvent* )_Event
    {
    NSPoint location = [ self convertPoint: [ _Event locationInWindow ] fromView: nil ];

    if ( NSPointInRect( location , customButtonFrame ) )
        if ( [ self lockFocusIfCanDraw ] )
            {
            [ self setNeedsDisplayInRect: customButtonFrame ];
            NSDrawThreePartImage( customButtonFrame
                                , _startCapImage, _centerFillImage, _endCapImage, NO, NSCompositeSourceOver, 1.f, YES );
            [ [ NSGraphicsContext currentContext ] flushGraphics ];
            [ self unlockFocus ];
            }
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
                            NSUInteger iterationCount = [ bitmapImageReps count ];

                            dispatch_apply( iterationCount, defaultGlobalDispatchQueue
                                , ^( size_t _CurrentIndex )
                                    {
                                    if ( [ self lockFocusIfCanDraw ] )
                                        {
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
                                        }
                                    else
                                        {
                                        if ( _CurrentIndex == ( iterationCount - 1 ) )
                                            {
                                            dispatch_async( dispatch_get_main_queue()
                                                , ^( void )
                                                    {
                                                    NSError* cannotDrawIntoView = [ NSError errorWithDomain: BLBezierLabErrorDomain code: BLFailureToDrawnIntoViewError userInfo: nil ];

                                                    [ self presentError: cannotDrawIntoView
                                                         modalForWindow: [ self window ]
                                                               delegate: self
                                                     didPresentSelector: @selector( didPresentErrorWithRecovery:contextInfo: )
                                                            contextInfo: nil ];
                                                    } );
                                            }
                                        }
                                    } );
                            }
                        else
                            {
                            if ( [ self lockFocusIfCanDraw ] )
                                {
                                NSImage* sourceImage = [ [ [ NSImage alloc ] initWithContentsOfURL: selectedURL ] autorelease ];
                                [ sourceImage setName: @"QingFeng" ];
                                [ sourceImage setName: nil ];

                                NSImage* destinationImage = [ NSImage imageNamed: @"QingFeng" ];

                                destinationImage = nil;

                                if ( destinationImage )
                                    {
                                    NSAffineTransform* translateTransformation = [ NSAffineTransform transform ];
                                    NSAffineTransformStruct translateTransformationStruct = { 1.f, 0.f, 0.f, 1.f, 20.f, 20.f };
                                    [ translateTransformation setTransformStruct: translateTransformationStruct ];

                                    NSPoint point = NSMakePoint( 50, 50 );

                                    [ destinationImage drawAtPoint: [ translateTransformation transformPoint: point ]
                                                          fromRect: NSZeroRect
                                                         operation: NSCompositeSourceOver
                                                          fraction: .8f ];
                                    }
                                else
                                    {
                                    dispatch_async( dispatch_get_main_queue()
                                        , ^( void )
                                            {
                                            NSError* failureToCreateDestImage = [ NSError errorWithDomain: BLBezierLabErrorDomain
                                                                                                     code: BLFailureToCreateImageError
                                                                                                 userInfo: nil ];
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

                                [ self drawTheCapturing ];

                                [ transform invert ];
                                [ transform concat ];

                                [ [ NSGraphicsContext currentContext ] flushGraphics ];

                                [ self unlockFocus ];
                                }
                            else
                                {
                                dispatch_async( dispatch_get_main_queue()
                                    , ^( void )
                                        {
                                        NSError* cannotDrawIntoView = [ NSError errorWithDomain: BLBezierLabErrorDomain code: BLFailureToDrawnIntoViewError userInfo: nil ];

                                        [ self presentError: cannotDrawIntoView
                                             modalForWindow: [ self window ]
                                                   delegate: self
                                         didPresentSelector: @selector( didPresentErrorWithRecovery:contextInfo: )
                                                contextInfo: nil ];
                                        } );
                                }
                            }
                        } );
                }
            } ];

    }

- ( IBAction ) checkToSeeIfAViewCanBeDrawn: ( id )_Sender
    {
    NSView* offscreenView = [ [ BLCompressionSchemesViewController compressionSchemesViewController ] view ];
    NSWindow* offscreenWindow = [ [ [ NSWindow alloc ] init ] autorelease ];

    NSLog( @"Can be drawn: %@", [ offscreenView canDraw ] ? @"YES" : @"NO" );

    [ [ offscreenWindow contentView ] addSubview: offscreenView ];

    NSLog( @"Can be drawn: %@", [ offscreenView canDraw ] ? @"YES" : @"NO" );
    }

- ( void ) drawTheCapturing
    {
#if 0
    NSImage* image = [ [ [ NSImage alloc ] initWithContentsOfURL: [ [ NSBundle mainBundle ] URLForResource: @"QingFeng" withExtension: @"png" ] ] autorelease ];

    [ image drawInRect: NSMakeRect( 500, 500, 300, 300 )
              fromRect: NSZeroRect
             operation: NSCompositeSourceOver
              fraction: 1.f ];

    [ image lockFocus ];
    NSBitmapImageRep* bitmapImageRep = [ [ [ NSBitmapImageRep alloc ] initWithFocusedViewRect: NSMakeRect( 0, 0, 100, 100 ) ] autorelease ];
    [ image unlockFocus ];

    [ bitmapImageRep drawInRect: NSMakeRect( 100, 300, 300, 300 )
                       fromRect: NSZeroRect
                      operation: NSCompositeSourceOver
                       fraction: 1.f
                 respectFlipped: YES
                          hints: nil ];
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

- ( BOOL ) attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex
    {
    return YES;
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

        case BLFailureToDrawnIntoViewError:
                {
                if ( _OptionIndex == 0 )
                    [ self setHidden: NO ];

                isRecoverSuccess = YES;
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
    NSMutableDictionary* newInfo = [ [ _Error userInfo ] mutableCopy ];

    if ( [ _Error.domain isEqualToString: BLBezierLabErrorDomain ] )
        {
        switch ( [ _Error code ] )
            {
        case BLFailureToCreateImageError:
                {
                newInfo[ NSLocalizedDescriptionKey ] = [ NSString stringWithFormat: NSLocalizedString( @"Failure to create the image which located at %@. Because the path is incorrect.", nil ), newInfo[ NSFilePathErrorKey ] ];
                newInfo[ NSLocalizedFailureReasonErrorKey ] = NSLocalizedString( @"Because the path is incorrect.", nil );
                newInfo[ NSLocalizedRecoverySuggestionErrorKey ] = NSLocalizedString( @"Choose a correct path and try again?", nil );
                newInfo[ NSLocalizedRecoveryOptionsErrorKey ] = @[ NSLocalizedString( @"Try again",nil ), NSLocalizedString( @"Cancel", nil ) ];
                newInfo[ NSRecoveryAttempterErrorKey ] = self;
                } break;

        case BLFailureToDrawnIntoViewError:
                {
                newInfo[ NSLocalizedDescriptionKey ] = NSLocalizedString( @"Failure to draw into the view. Because the view has been hidden.", nil );
                newInfo[ NSLocalizedFailureReasonErrorKey ] = NSLocalizedString( @"Because the view has been hidden.", nil );
                newInfo[ NSLocalizedRecoverySuggestionErrorKey ] = NSLocalizedString( @"Would you like to show the currently hidden view and try again?", nil );
                newInfo[ NSLocalizedRecoveryOptionsErrorKey ] = @[ NSLocalizedString( @"Try Again", nil ), NSLocalizedString( @"Cancel", nil ) ];
                newInfo[ NSRecoveryAttempterErrorKey ] = self;
                } break;
            }
        }

    return [ super willPresentError: [ NSError errorWithDomain: _Error.domain
                                                          code: _Error.code
                                                      userInfo: newInfo ] ];
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