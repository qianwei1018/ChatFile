//
//  Message.h
//  机器人
//
//  Created by sq-ios25 on 16/3/6.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    MessageTypeMe = 0 , // 自己发的
    MessageTypeOther = 1    // 别人发的
}MessageType;

@interface Message : NSObject

@property(nonatomic,copy)NSString *url;
//标示码
@property(nonatomic,copy)NSString *code;
//文字内容
@property(nonatomic,copy)NSString *text;
//
@property(nonatomic,copy)NSString *time;

@property(nonatomic,assign)MessageType *type;



@end
