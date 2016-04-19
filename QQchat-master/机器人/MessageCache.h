//
//  MessageCache.h
//  机器人
//
//  Created by sq-ios25 on 16/3/6.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessageCache : NSObject

+(void)addMessage:(NSString *)str type:(int)type;

+(NSMutableArray *)display;

+(void)deletetable;

@end
