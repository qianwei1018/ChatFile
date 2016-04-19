//
//  AboutViewController.m
//  机器人
//
//  Created by qianwei on 16/3/15.
//  Copyright © 2016年 OHS. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor whiteColor];

    self.tableView.scrollEnabled = NO;
    
}


/**
 *  选中看详情
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self addAlertBox:@"简介" message:@"智能聊天机器人" actionTitle:@"确定"];
    } else if (indexPath.row == 1) {
        [self addAlertBox:@"版本" message:@"版本2.0" actionTitle:@"确定"];
        
    } else if (indexPath.row == 2) {
       [self addAlertBox:@"开发者信息" message:@"By qianwei From 安科" actionTitle:@"确定"];
        
    } else {
        
    }
}


/**
 *  alert 警告框
 *
 *  @param title       alert title
 *  @param message     message
 *  @param actionAlert actionAlert
 */
- (void)addAlertBox:(NSString *)title
            message:(NSString *)message
        actionTitle:(NSString*)actionAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:actionAlert style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}



@end
