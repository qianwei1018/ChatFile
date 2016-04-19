//
//  AddView.m
//  机器人
//
//  Created by sq-ios25 on 16/3/10.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//


#define reuseIdentifier @"cell";

#import "AddView.h"
#import "AddViewButton.h"


@interface AddView()
@property(nonatomic,weak)AddViewButton *btn1;
@property(nonatomic,weak)AddViewButton *btn2;
@property(nonatomic,weak)AddViewButton *btn3;
@property(nonatomic,weak)AddViewButton *btn4;
@property(nonatomic,weak)AddViewButton *btn5;
@property(nonatomic,weak)AddViewButton *btn6;

@end

@implementation AddView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        
        [self setupButton];
        
    }
    return self;
}

/**
 *  设置按钮
 */
-(void)setupButton {
    AddViewButton *btn1 = [[AddViewButton alloc]initWithFrame:CGRectMake(40, 30, 60, 80)];
    [btn1 setImage:[UIImage imageNamed:@"photo3"] forState:UIControlStateNormal];
    [btn1 setTitle:@"你好" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn1];
    self.btn1 = btn1;
    
    AddViewButton *btn2 = [[AddViewButton alloc]initWithFrame:CGRectMake(130, 30, 60, 80)];
    [btn2 setImage:[UIImage imageNamed:@"photo3"] forState:UIControlStateNormal];
    [btn2 setTitle:@"笑话" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2click) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn2];
    self.btn2 = btn2;
    
    AddViewButton *btn3 = [[AddViewButton alloc]initWithFrame:CGRectMake(220, 30, 60, 80)];
    [btn3 setImage:[UIImage imageNamed:@"photo3"] forState:UIControlStateNormal];
    [btn3 setTitle:@"图片" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btn3click) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn3];
    self.btn3 = btn3;
    
    AddViewButton *btn4 = [[AddViewButton alloc]initWithFrame:CGRectMake(40, 120, 60, 80)];
    [btn4 setImage:[UIImage imageNamed:@"photo3"] forState:UIControlStateNormal];
    [btn4 setTitle:@"火车票" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(btn4click) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn4];
    self.btn4 = btn4;

    AddViewButton *btn5 = [[AddViewButton alloc]initWithFrame:CGRectMake(130, 120, 60, 80)];
    [btn5 setImage:[UIImage imageNamed:@"photo3"] forState:UIControlStateNormal];
    [btn5 setTitle:@"故事" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(btn5click) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn5];
    self.btn5 = btn5;
    
    AddViewButton *btn6 = [[AddViewButton alloc]initWithFrame:CGRectMake(220, 120, 60, 80)];
    [btn6 setImage:[UIImage imageNamed:@"photo3"] forState:UIControlStateNormal];
    [btn6 setTitle:@"天气" forState:UIControlStateNormal];
    [btn6 addTarget:self action:@selector(btn6click) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn6];
    self.btn6 = btn6;
    
    
    
}



-(void)btn1click {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NSJOKE" object:self.btn1.titleLabel.text];
}

-(void)btn2click {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NSJJJ" object:self.btn2.titleLabel.text];

}
-(void)btn3click {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PHOTO" object:self.btn3.titleLabel.text];

}
-(void)btn4click {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"aaa" object:self.btn4.titleLabel.text];

}
-(void)btn5click {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"STORY" object:self.btn5.titleLabel.text];
}
-(void)btn6click {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"WEATHER" object:self.btn6.titleLabel.text];
}



@end
