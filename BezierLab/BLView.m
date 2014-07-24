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

// BLView class
@implementation BLView

- ( void ) awakeFromNib
    {
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
- ( IBAction ) testingForImageRep: ( id )_Sender
    {
    NSOpenPanel* openPanel = [ NSOpenPanel openPanel ];

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
                        NSData* imageData = [ NSData dataWithContentsOfURL: [ openPanel URL ] ];
                        NSArray* bitmapImageReps = [ NSBitmapImageRep imageRepsWithData: imageData ];

                        dispatch_apply( [ bitmapImageReps count ], defaultGlobalDispatchQueue
                            , ^( size_t _CurrentIndex )
                                {
                                [ self lockFocusIfCanDraw ];
                            #if 1
                                NSAffineTransform* flipTransform = [ NSAffineTransform transform ];
                                NSAffineTransformStruct flipTransformStruct = { 1.f, .0f, .0f, -1.f, .0f, self.bounds.size.height };
                                [ flipTransform setTransformStruct: flipTransformStruct ];
                                [ flipTransform concat ];
                            #endif
                                srand( ( int )time( NULL ) );
                                NSRect rect = NSMakeRect( random() % ( long )self.bounds.size.width
                                                        , random() % ( long )self.bounds.size.height
                                                        , 100, 100 ) ;

                                NSBitmapImageRep* imageRep = ( NSBitmapImageRep* )bitmapImageReps[ _CurrentIndex ];
                                [ imageRep drawInRect: rect ];

                                [ [ NSGraphicsContext currentContext ] flushGraphics ];
                            #if 1
                                [ flipTransform invert ];
                                [ flipTransform concat ];
                            #endif
                                [ self unlockFocus ];
                                } );
                        } );
                }
            } ];

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