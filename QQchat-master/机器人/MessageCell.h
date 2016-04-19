//
//  MessageCell.h
//  机器人
//
//  Created by sq-ios25 on 16/3/6.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageFrame;
@interface MessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) MessageFrame *messageFrame;

@end
