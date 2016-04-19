//
//  MessageFrame.h
//  机器人
//
//  Created by sq-ios25 on 16/3/6.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Message;
@interface MessageFrame : NSObject

/**
 *  头像的frame
 */
@property (nonatomic, assign, readonly) CGRect iconF;
/**
 *  时间的frame
 */
@property (nonatomic, assign, readonly) CGRect timeF;
/**
 *  正文的frame
 */
@property (nonatomic, assign, readonly) CGRect textF;
/**
 *  cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

/**
 *  数据模型
 */
@property (nonatomic, strong) Message *message;


@end
