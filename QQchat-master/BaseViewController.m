//
//  BaseViewController.m
//  机器人
//
//  Created by sq-ios25 on 16/3/11.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUIAppearce];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];
}


-(void)handleThemeChanged
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    [self.navigationController.navigationBar setBackgroundImage:[defaultManager themedImageWithName:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    [self configUIAppearce];
}


-(void)configUIAppearce
{
    
}

@end
