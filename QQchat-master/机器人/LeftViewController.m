//
//  LeftViewController.m
//  机器人
//
//  Created by sq-ios25 on 16/3/5.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "LeftViewController.h"
#import "DDMenuController.h"
#import "ViewController.h"
#import "SettingViewController.h"
#import "HelpViewController.h"
#import "NavigationController.h"
#import "BackgroundViewController.h"

@interface LeftViewController ()
@property(nonatomic, strong)NSArray *Item;
@property(nonatomic, strong)NSArray *imageName;

@end

@implementation LeftViewController


- (NSArray *)Item {
    if (_Item == nil) {
        
        _Item = [[NSArray alloc]initWithObjects:@"聊天",@"主题",@"设置",@"帮助", nil];
        
    }
    return _Item;
}

- (NSArray *)imageName {
    if (_imageName == nil) {
        _imageName = [[NSArray alloc] initWithObjects:@"liaotian",@"zhuti",@"shezhi",@"bangzhu", nil];
    }
    return _imageName;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.tableView.scrollEnabled = NO;

  //  self.tableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    ThemeManager *mana = [ThemeManager sharedInstance];
    self.tableView.backgroundColor = [mana themeColor];
    
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
    
    //给表格下面没有用到的cell覆盖
    UIView *view2 = [[UIView alloc]init];
    [view2 setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:view2];


}





#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.Item.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.textLabel.text = self.Item[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageName[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor grayColor];
    
    
    
    return cell;
}

/**
 *  选中tableViewCell时
 *
 *  @param tableView 出现的tableView
 *  @param indexPath 选中的位置
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIStoryboard *story = [self storyboard];
        ViewController *vc = [story instantiateViewControllerWithIdentifier:@"MainViewControl"];
        NavigationController *nav = [[NavigationController alloc]initWithRootViewController:vc];
        
        DDMenuController *dd = (DDMenuController*)[UIApplication sharedApplication].delegate.window.rootViewController;
        [dd setRootController:nav animated:YES];
        
    } else if (indexPath.row == 1) {
        
        BackgroundViewController *vc1 = [[BackgroundViewController alloc]init];
        
        NavigationController *nav1 = [[NavigationController alloc]initWithRootViewController:vc1];
        DDMenuController *dd = (DDMenuController*)[UIApplication sharedApplication].delegate.window.rootViewController;
        [dd setRootController:nav1 animated:YES];
        
    } else if (indexPath.row == 2) {
        SettingViewController *vc1 = [[SettingViewController alloc]init];
        NavigationController *nav1 = [[NavigationController alloc]initWithRootViewController:vc1];
        DDMenuController *dd = (DDMenuController*)[UIApplication sharedApplication].delegate.window.rootViewController;
        [dd setRootController:nav1 animated:YES];
    
    } else {
        
        UIStoryboard *story = [self storyboard];
        HelpViewController *vc1 = [story instantiateViewControllerWithIdentifier:@"Help"];
        
        NavigationController *nav1 = [[NavigationController alloc]initWithRootViewController:vc1];
        DDMenuController *dd = (DDMenuController*)[UIApplication sharedApplication].delegate.window.rootViewController;
        [dd setRootController:nav1 animated:YES];
        
    }
}


//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


@end
