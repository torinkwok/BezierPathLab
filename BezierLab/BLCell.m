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

#import "BLCell.h"

// BLCell class
@implementation BLCell

- ( void ) drawWithFrame: ( NSRect )_CellFrame inView: ( NSView* )_ControlView
    {
//    if ( [ _ControlView lockFocusIfCanDraw  ] )
//        {
//        NSBezierPath* path = [ NSBezierPath bezierPathWithOvalInRect: _CellFrame ];
//        [ [ NSColor magentaColor ] set ];
//        [ path stroke ];
//
//        [ [ NSGraphicsContext currentContext ] flushGraphics ];
//        [ _ControlView unlockFocus ];
//        }

#if 1
    if ( [ _ControlView lockFocusIfCanDraw ] )
        {
        NSImage* imageLeft = [ [ [ NSImage alloc ] initWithContentsOfFile: @"/Users/EsquireTongG/black-button-mouse-down-left.tiff" ] autorelease ];
        NSImage* imageCenter = [ [ [ NSImage alloc ] initWithContentsOfFile: @"/Users/EsquireTongG/black-button-mouse-down-middle.tiff" ] autorelease ];
        NSImage* imageRight = [ [ [ NSImage alloc ] initWithContentsOfFile: @"/Users/EsquireTongG/black-button-mouse-down-right.tiff" ] autorelease ];

        NSDrawThreePartImage( _CellFrame, imageLeft, imageCenter, imageRight, NO, NSCompositeSourceOver, 1.f, NO );

        if ( [ self showsFirstResponder ] )
            {
            // showsFirstResponder is set for us by the NSControl that is drawing us.
            NSRect focusRingFrame = _CellFrame;
//            focusRingFrame.size.height -= 2.f;

            [ NSGraphicsContext saveGraphicsState ];
                NSSetFocusRingStyle( NSFocusRingOnly );
                [ [ NSBezierPath bezierPathWithRoundedRect: focusRingFrame xRadius: 2 yRadius: 2 ] fill ];
            [ NSGraphicsContext restoreGraphicsState ];
            }

        [ [ NSGraphicsContext currentContext ] flushGraphics ];
        [ _ControlView unlockFocus ];
        }
#endif
    }

- ( BOOL ) trackMouse: ( NSEvent* )_Event
               inRect: ( NSRect )_CellFrame
               ofView: ( NSView* )_ControlView
         untilMouseUp: ( BOOL )_UntilMouseup
    {
    return YES;
    }

@end // BLCell

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