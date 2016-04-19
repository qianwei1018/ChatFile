//
//  NavigationController.m
//  机器人
//
//  Created by sq-ios25 on 16/3/6.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "NavigationController.h"
#import "UIBarButtonItem+gyh.h"
#import "ThemeManager.h"


@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //主题的选择
//   ThemeManager *defaultManager = [ThemeManager sharedInstance];
//    [[UINavigationBar appearance]setBarTintColor:[defaultManager themeColor]];
    

    
    
    
    
//    [[UINavigationBar appearance]setBackgroundImage:[defaultManager themedImageWithName:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    
      //  [self.navigationItem.titleView setTintColor:[UIColor redColor]];
        
      //  UIImage *backgroundImage = [self imageWithColor:[defaultManager themeColor]];
     //   [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
   
}


//拦截所有push控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithIcon:@"navigationbar_back_os7" highIcon:nil target:self action:@selector(back)];
        

    [super pushViewController:viewController animated:animated];
}

-(void)back {
    [self popViewControllerAnimated:YES];
    
}


@end
