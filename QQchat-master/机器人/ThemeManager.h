//
//  ThemeManager.h
//  机器人
//
//  Created by sq-ios25 on 16/3/12.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#define Bundle_Of_ThemeResource @"ThemeResource"
#define Bundle_Path_Of_ThemeResource [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:Bundle_Of_ThemeResource]


#define Notice_Theme_Changed @"Notice_Theme_Changed"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeManager : NSObject

@property(nonatomic,copy)NSString *themeName;
@property(nonatomic,copy)NSString *themePath;
@property(nonatomic,strong)UIColor *themeColor;


+ (ThemeManager*)sharedInstance;

-(void)changeThemeWithName:(NSString*)themeName;

- (UIImage*)themedImageWithName:(NSString*)imgName;

-(NSArray *)listOfAllTheme;


@end
