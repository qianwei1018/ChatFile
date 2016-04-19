//
//  SettingViewController.m
//  机器人
//
//  Created by qianwei on 16/3/15.
//  Copyright © 2016年 OHS. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "SuggestViewController.h"
#import "MessageCache.h"

#import "MBProgressHUD+MJ.h"
#import <ShareSDK/ShareSDK.h>


@interface SettingViewController ()
@property(nonatomic, strong) NSArray *items;
@property(nonatomic, strong) NSArray *imageName;

@end

@implementation SettingViewController

- (instancetype)init
{
    
    return [super initWithStyle:UITableViewStyleGrouped];
}

-(NSArray *)items {
    if (_items == nil) {
        NSArray *array1 = [[NSArray alloc]initWithObjects:@"清除聊天记录",@"意见反馈", nil];
        NSArray *array2 = [[NSArray alloc]initWithObjects:@"关于",@"分享", nil];
        _items = [[NSArray alloc]initWithObjects:array1,array2,nil];
       // _items = [[NSArray alloc]initWithObjects:@"清除聊天记录",@"意见反馈",@"关于",@"分享", nil];
    }
    return _items;
}

-(NSArray *)imageName {
    if (_imageName == nil) {
        NSArray *array1 = [[NSArray alloc]initWithObjects:@"清除聊天记录",@"意见反馈", nil];
        NSArray *array2 = [[NSArray alloc]initWithObjects:@"关于",@"分享", nil];
        _imageName = [[NSArray alloc]initWithObjects:array1,array2,nil];
        // _items = [[NSArray alloc]initWithObjects:@"清除聊天记录",@"意见反馈",@"关于",@"分享", nil];
    }
    return _imageName;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
//    ThemeManager *mana = [ThemeManager sharedInstance];
//    self.tableView.backgroundColor = [mana themeColor];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 10)];
    
    //给表格下面没有用到的cell覆盖
    UIView *view2 = [[UIView alloc]init];
    [view2 setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:view2];

}


#pragma mark 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sec = self.items[section];
    return sec.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建cell
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.items[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageName[indexPath.section][indexPath.row]];
//    cell.imageView.image = [UIImage imageNamed:@"chat_bottom_smile_nor"];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除" message:@"是否清空所有消息" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }];
            [alert addAction:cancelAction];
            UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"清空");
                
                [MessageCache deletetable];
                [MBProgressHUD showSuccess:@"清除完毕"];
                
            }];
            [alert addAction:shareAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            
           
        }else if (indexPath.row == 1){
            SuggestViewController *sugg = [[SuggestViewController alloc]init];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            sugg = [story instantiateViewControllerWithIdentifier:@"suggest"];
            [self.navigationController pushViewController:sugg animated:YES];
        }
        
    }else{
        if (indexPath.row == 0) {
            
            AboutViewController *about = [[AboutViewController alloc]init];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            about = [story instantiateViewControllerWithIdentifier:@"About"];
            [self.navigationController pushViewController:about animated:YES];
            
        }else{
            
            [self show];
            
        }
    }
   
}

-(void)show {
  //  NSString *imagePath = @"girl1";
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"智能聊天机器人"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"222"]]
                                                title:@"机器人"
                                                  url:@"http://www.tuling123.com"
                                          description:@"shenm"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"分享成功！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                    NSString *errorMassage = [[NSString alloc] initWithFormat:@"分享失败！\n %@",[error errorDescription]];
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorMassage delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                                    [alert show];
                                    
                                }
                            }];

}


@end
