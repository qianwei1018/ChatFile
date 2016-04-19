//
//  MessageFrame.m
//  机器人
//
//  Created by sq-ios25 on 16/3/6.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#define MJTextFont [UIFont systemFontOfSize:15];

// 正文的内边距
#define MJTextPadding 20

#import "MessageFrame.h"
#import "Message.h"
#import "NSString+Extension.h"

@implementation MessageFrame

///**
// *  计算文字尺寸
// *
// *  @param text    需要计算尺寸的文字
// *  @param font    文字的字体
// *  @param maxSize 文字的最大尺寸
// */
//- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
//{
//    NSDictionary *attrs = @{NSFontAttributeName:font};
//    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//}

- (void)setMessage:(Message *)message
{
    _message = message;
    // 间距
    CGFloat padding = 10;
    // 屏幕的宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 1.时间
    CGFloat timeX = 0;
    CGFloat timeY = 0;
    CGFloat timeW = screenW;
    CGFloat timeH = 40;
    _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    
    // 2.头像
    CGFloat iconY = CGRectGetMaxY(_timeF);
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    CGFloat iconX;
    if (message.type == MessageTypeOther) {// 别人发的
        iconX = padding;
    } else { // 自己的发的
        iconX = screenW - padding - iconW;
    }
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    
    // 3.正文

    CGSize textBtnSize;
    
    // 文字计算的最大尺寸
    CGSize textMaxSize = CGSizeMake(200, MAXFLOAT);
    // 文字计算出来的真实尺寸(按钮内部label的尺寸)
    CGSize textRealSize = [message.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:textMaxSize];
    // 按钮最终的真实尺寸
    textBtnSize = CGSizeMake(textRealSize.width + MJTextPadding * 2, textRealSize.height + MJTextPadding * 2);
    
    CGFloat textY = iconY;

    
    CGFloat textX;
    if (message.type == MessageTypeOther) {// 别人发的
        textX = CGRectGetMaxX(_iconF) + padding;
    } else {// 自己的发的
        textX = iconX - padding - textBtnSize.width;
    }

    _textF = (CGRect){{textX, textY}, textBtnSize};
  

    
    
    // 4.cell的高度
    CGFloat textMaxY = CGRectGetMaxY(_textF);
    CGFloat iconMaxY = CGRectGetMaxY(_iconF);
    _cellHeight = MAX(textMaxY, iconMaxY) + padding;
}


@end
