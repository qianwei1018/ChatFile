//
//  MessageCell.m
//  机器人
//
//  Created by sq-ios25 on 16/3/6.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//


#define MJTextFont [UIFont systemFontOfSize:15];

// 正文的内边距
#define MJTextPadding 20


#import "MessageCell.h"
#import "MessageFrame.h"
#import "Message.h"
#import "UIImage+Extension.h"


@interface MessageCell()

/**
 *  时间
 */
@property (nonatomic, weak) UILabel *timeView;
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;
/**
 *  正文
 */
@property (nonatomic, weak) UIButton *textView;


@end

@implementation MessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"message";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //初始化子控件
        //时间
        UILabel *timeView = [[UILabel alloc]init];
        timeView.textAlignment = NSTextAlignmentCenter;
        timeView.textColor = [UIColor grayColor];
        timeView.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:timeView];
        self.timeView = timeView;
        
        //头像
        UIImageView *iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        // 3.正文
        UIButton *textView = [[UIButton alloc] init];
        textView.titleLabel.numberOfLines = 0; // 自动换行
        textView.titleLabel.font = MJTextFont;
        textView.contentEdgeInsets = UIEdgeInsetsMake(MJTextPadding, MJTextPadding, MJTextPadding, MJTextPadding);
        
        [textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:textView];
        self.textView = textView;
        
        
        //清除cell的背景色
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;

}


- (void)setMessageFrame:(MessageFrame *)messageFrame {
    _messageFrame = messageFrame;
    
    Message *message = messageFrame.message;
    
    // 1.时间
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentTime = [df stringFromDate:date];
    
    self.timeView.text = currentTime;
    self.timeView.frame = messageFrame.timeF;
    
    // 2.头像
    NSString *icon = (message.type == MessageTypeMe) ? @"2" : @"1";
    self.iconView.image = [UIImage imageNamed:icon];
    self.iconView.frame = messageFrame.iconF;
    
    // 3.正文
    [self.textView setTitle:message.text forState:UIControlStateNormal];
    self.textView.frame = messageFrame.textF;
    
    // 4.正文的背景
    if (message.type == MessageTypeOther) { // 别人发的,蓝色
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_recive_nor"] forState:UIControlStateNormal];
    } else { // 自己发的,白色
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_send_nor"] forState:UIControlStateNormal];
    }

}


@end
