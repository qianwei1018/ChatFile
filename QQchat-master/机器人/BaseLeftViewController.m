//
//  BaseLeftViewController.m
//  机器人
//
//  Created by sq-ios25 on 16/3/12.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "BaseLeftViewController.h"

@interface BaseLeftViewController ()

@end

@implementation BaseLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUIAppearce];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];
}


-(void)handleThemeChanged
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    [self.navigationController.navigationBar setBackgroundImage:[defaultManager themedImageWithName:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    self.tableView.backgroundColor = [defaultManager themeColor];
    [self configUIAppearce];
}


#pragma mark - 主题切换
-(void)configUIAppearce {
    
}


@end
