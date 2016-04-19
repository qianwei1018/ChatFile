//
//  AppDelegate.m
//  机器人
//
//  Created by sq-ios25 on 16/3/4.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "AppDelegate.h"
#import "DDMenuController.h"
#import "ViewController.h"
#import "LeftViewController.h"
#import "NavigationController.h"

#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlySpeechUtility.h>

#import "MyTulingHeader.h"
#import <ShareSDK/ShareSDK.h>
#import"WeiboApi.h"
#import<TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import <UMSocial.h>
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"



@interface AppDelegate ()
@property(nonatomic,strong)ViewController *vc;
@property(nonatomic,strong)DDMenuController *dd;

@end

@implementation AppDelegate


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //友盟分享KEY
    [UMSocialData setAppKey:UMSHAREKEY];

    //微信   AppID：wxd5d4138162361362
    [UMSocialWechatHandler setWXAppId:@"wxd5d4138162361362" appSecret:@"9abe7f50a793deca4c0b3cba815300c6" url:@"http://www.umeng.com/social"];
    
    //分享APP
    [ShareSDK registerApp:@"7f2688ca1e49"];
    [ShareSDK connectSMS];
    [ShareSDK connectMail];
    /*Sina*/
    [ShareSDK connectSinaWeiboWithAppKey:@"3228337151" appSecret:@"e2a93a425c5f14a1867862134e2a8ecd" redirectUri:@"http://sns.whalecloud.com/sina2/callback"];
    

//    //语音接口
//    NSString *initstring = [[NSString alloc]initWithFormat:@"appid=%@",@"5708c023" ];
//    [IFlySpeechUtility createUtility:initstring];
    
    
    
    [self showUI];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




- (void) showUI {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [story instantiateViewControllerWithIdentifier:@"MainViewControl"];
    LeftViewController *leftVC = [story instantiateViewControllerWithIdentifier:@"LeftViewController"];
    self.dd = [[DDMenuController alloc]init];
    self.dd.leftViewController = leftVC;
    self.dd.rightViewController = nil;
    NavigationController *navic = [[NavigationController alloc]initWithRootViewController:self.vc];
    self.dd.rootViewController= navic;
    self.window.rootViewController = self.dd;
    
}


@end
