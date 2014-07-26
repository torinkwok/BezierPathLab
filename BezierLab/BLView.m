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

// BLView class
@implementation BLView

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

                            dispatch_async( dispatch_get_main_queue()
                                , ^( void )
                                    {
                                    NSData* TIFFData = [ sourceImage TIFFRepresentationUsingCompression: NSTIFFCompressionJPEG factor: 1.f ];

                                    if ( TIFFData )
                                        {
                                        NSSavePanel* savePanel = [ NSSavePanel savePanel ];
                                        BLCompressionSchemesViewController* compressionSchemesViewController = [ BLCompressionSchemesViewController compressionSchemesViewController ];
                                        [ savePanel setAccessoryView: [ compressionSchemesViewController view ] ];

                                        [ savePanel setExtensionHidden: YES ];
                                        [ savePanel beginSheetModalForWindow: [ self window ]
                                                           completionHandler:
                                            ^( NSInteger _Result )
                                                {
                                                if ( _Result == NSFileHandlingPanelOKButton )
                                                    [ TIFFData writeToURL: [ savePanel URL ] atomically: YES ];
                                                } ];
                                        }
                                    else
                                        {
                                        NSLog( @"Fuck" );
                                        }
                                    } );

                            NSImage* destinationImage = [ [ [ NSImage alloc ] initWithContentsOfURL: [ NSURL URLWithString: @"file:///Users/EsquireTongG/QingFeng.png" ] ] autorelease ];

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