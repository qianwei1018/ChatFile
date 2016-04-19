//
//  SuggestViewController.m
//  机器人
//
//  Created by qianwei on 16/3/18.
//  Copyright © 2016年 OHS. All rights reserved.
//

#import "SuggestViewController.h"
#import "ThemeManager.h"
#import "MBProgressHUD+MJ.h"
#import <MessageUI/MessageUI.h>

@interface SuggestViewController ()<MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIButton *suggest;
- (IBAction)Suggest;

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupinit];
   
}

-(void)setupinit
{
     self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    
    ThemeManager *man = [ThemeManager sharedInstance];
    self.suggest.backgroundColor = [man themeColor];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textview resignFirstResponder];
}


- (IBAction)Suggest {
    
    if (!self.textview.text.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        //调用Safari
//        [[UIApplication sharedApplication] ];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://qianwei_1018@163.com"]];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://18010912021"]];
        [MBProgressHUD showSuccess:@"意见反馈成功"];

        
    }else{
        [MBProgressHUD showError:@"反馈内容不能为空"];
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            [self addAlertBox:@"提示" message:@"信息传送成功" actionTitle:@"确定"];
            break;
        case
        MessageComposeResultFailed:
            [self addAlertBox:@"提示" message:@"信息传送失败" actionTitle:@"确定"];
            break;
        case
        MessageComposeResultCancelled:
            [self addAlertBox:@"提示" message:@"信息被用户取消传送" actionTitle:@"确定"];
            break;
        default:
            break;
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
