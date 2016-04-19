//
//  ViewController.m
//  机器人
//
//  Created by sq-ios25 on 16/3/4.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "ViewController.h"
#import "MyTulingHeader.h"

#import "MessageFrame.h"
#import "Message.h"
#import "MessageCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "AddView.h"
#import "UIBarButtonItem+gyh.h"
#import "MoreViewController.h"
#import "MessageCache.h"
#import "MBProgressHUD+MJ.h"

#import <UMSocial.h>
#import <AFNetworking.h>

#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlySpeechConstant.h>
#import "iflyMSC/IFlyContact.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyUserWords.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechUnderstander.h"
#import <iflyMSC/IFlySpeechRecognizerDelegate.h>


@class PopupView;
@class IFlyDataUploader;
@class IFlySpeechUnderstander;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UMSocialUIDelegate,IFlyRecognizerViewDelegate,IFlySpeechRecognizerDelegate>
{
    IFlyRecognizerView      *_iflyRecognizerView;
    
    /**
     *  网络返回的URL
     */
    NSString *contentURLStr;
    
    
    /**
     *  文本框内容
     */
    NSString *contentStr;
}
/**
 *  工具栏
 */
@property (weak, nonatomic) IBOutlet UIView *toolView;
/**
 *  声音按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sound;
/**
 *  声音按钮动作
 */
-(IBAction)soundvoice;

@property (weak, nonatomic) IBOutlet UIButton *btn;
/**
 *  聊天框
 */
@property (weak, nonatomic) IBOutlet UITextField *inputView;
/**
 *  快捷输入按钮
 */
- (IBAction)addView;

@property (nonatomic, strong) NSMutableArray *messageFrames;

@property (weak,  nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, readwrite)UIInputView *input;

@property (nonatomic, strong) IFlyDataUploader *uploader;//数据上传对象
@property (nonatomic, strong) PopupView *popUpView;



@property (nonatomic,strong) IFlySpeechUnderstander *iFlySpeechUnderstander;
@property (nonatomic,strong) NSString               *result;
@property (nonatomic,strong) NSString               *str_result;
@property (nonatomic)         BOOL                  isCanceled;



@end

@implementation ViewController

- (IBAction) addView {
    
    UITextView *test = [[UITextView alloc]init];
    test.delegate = self;
    [self.btn addSubview:test];
    
    AddView *view = [[AddView alloc]initWithFrame:CGRectMake(0, 449, 375, 218)];
    
    test.inputAccessoryView = nil;
    test.inputView = nil;
    test.inputView = view;
    
    [test becomeFirstResponder];
    
    if (self.btn.tag == 0) {

         NSLog(@"1");

        self.btn.tag = 1;
        
    }else {
        NSLog(@"2");

        [test resignFirstResponder];
     
        self.btn.tag = 0;
        
    }
  
}

//懒加载messageFrames
- (NSMutableArray *)messageFrames {
    if (_messageFrames == nil) {
        
        _messageFrames = [[NSMutableArray alloc]init];
        
    }
    return _messageFrames;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageFrames = [MessageCache display];
 
    self.title = @"聊天";
    
    self.btn.tag = 0;
    
    [self.btn setImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateHighlighted];
    
    //MoreViewController 界面
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithIcon:@"navigationbar_friendsearch_os7" highIcon:@"navigationbar_friendsearch_highlighted_os7" target:self action:@selector(more)];
    
    // 去除分割线

    //设置背景图片

    self.tableview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
   
    //主题
    ThemeManager *manager = [ThemeManager sharedInstance];
    self.toolView.backgroundColor = [manager themeColor];

    self.tableview.alpha = 1.0;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.allowsSelection = NO; // 不允许选中
    self.tableview.delegate = self;
    
    //监听键盘的frame改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(click:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    //设置输入框左边的间距
    self.inputView.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.inputView.leftViewMode = UITextFieldViewModeAlways;
    self.inputView.delegate = self;
    
//    //进去页面，首先显示一条数据
//    NSString *ns = @"您好！有什么想知道的都可以问我哦！";
//    [self inputMessage:ns url:nil type:MessageTypeOther];
    
    [self notification];
    
    //滚动至最一行
    if (_messageFrames.count > 1) {
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
        [self.tableview scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    
    //语音功能配置
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",@"5715836d",@"20000"];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    _iFlySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
    _iFlySpeechUnderstander.delegate = self;
    
    
    
    
    //添加长按手势
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(doLongPress:)];
    [self.tableview addGestureRecognizer:longPressGR];
    //添加点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton)];
    [self.tableview addGestureRecognizer:tapGR];
    
    //语音长按手势
    UILongPressGestureRecognizer *longPressGR2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(doLongPress2:)];
    [self.sound addGestureRecognizer:longPressGR2];

}

/**
 *  导航栏右侧按钮
 */
- (void)more {
    MoreViewController *mv = [[MoreViewController alloc]init];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    mv = [story instantiateViewControllerWithIdentifier:@"More"];
    [self.navigationController pushViewController:mv animated:YES];
}

- (void)notification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(event:) name:@"NSJOKE" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(event:) name:@"NSJJJ" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(event:) name:@"PHOTO" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(event:) name:@"aaa" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(event:) name:@"STORY" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(event:) name:@"WEATHER" object:nil];
    
    
}

- (void)event:(NSNotification *)notifition {
    [self inputMessage:notifition.object url:nil type:MessageTypeMe];
    [self replayWithText:notifition.object];
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  键盘通知方法
 *
 *  @param note 键盘通知的参数
 */
- (void)click:(NSNotification *)note {
   
    self.view.window.backgroundColor = self.tableview.backgroundColor;
    
    // 取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    // 取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];

}



#pragma mark 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.创建cell
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    
    //2.传递数据
    cell.messageFrame = self.messageFrames[indexPath.row];
    
    //3.返回cell
    return cell;
}


//代理方法，退出键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageFrame *mf = self.messageFrames[indexPath.row];
    return mf.cellHeight;
}



#pragma mark 文本框代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   
    //自己发送消息
    [self inputMessage:textField.text url:nil type:0];

    //对方回复的
    [self replayWithText:textField.text];

    self.inputView.text = nil;
    
    return YES;
}

#pragma mark - 网络请求
/**
 *  对方回复的信息
 *
 *  @param text 传入数据
 */
- (void)replayWithText:(NSString *)infoString {

    //http://www.tuling123.com/openapi/api?key=78aaf0702f48805fdaf8d07492eef0ae&info=
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    parms[@"info"] = infoString;
    [manager POST:URLAPIKEY parameters:parms progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        NSLog(@"responseObject%@",responseObject);
        
        NSString *ns = responseObject[@"text"];
        
        /**
         *  分类解析返回数据
         */
        if ([[responseObject allKeys] containsObject:@"list"]) {
            NSDictionary *arrayDict;
            NSArray *listArray = [responseObject valueForKey:@"list"];
            arrayDict = listArray[0];
            
            //新闻类
            if ([[arrayDict allKeys] containsObject:@"article"]) {
                
                ns = [NSString stringWithFormat:@"%@\n%@\n",ns,[arrayDict valueForKey:@"article"]];
                
                [self inputMessage:ns url:[arrayDict valueForKey: @"detailurl"] type:1];
                
                contentStr = [NSString stringWithFormat:@"%@%@",ns,[arrayDict valueForKey: @"detailurl"]];
                
                contentURLStr = [arrayDict valueForKey: @"detailurl"];
                
                //菜单类
            } else if ([[arrayDict allKeys] containsObject:@"name"]) {
                ns = [NSString stringWithFormat:@"%@\n%@\n",[arrayDict valueForKey:@"name"],[arrayDict valueForKey:@"info"]];
                
                [self inputMessage:ns url:[arrayDict valueForKey:@"detailurl"] type:1];
                
                contentStr = [NSString stringWithFormat:@"%@%@",ns,[arrayDict valueForKey: @"detailurl"]];
                
                contentURLStr = [arrayDict valueForKey: @"detailurl"];
            }
            
        } else {      //其他类
//        NSString *ns = responseObject[@"text"];
        NSString *nss = responseObject[@"url"];
        NSDictionary *dic = responseObject[@"list"];
        NSLog(@"%@,%@---%@",ns,nss,dic);
        [self inputMessage:ns url:nss type:1];
        
        contentStr = [NSString stringWithFormat:@"%@%@",ns,nss];
        
        contentURLStr = nss;
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure:%@",error);
    }];


}


-(void)inputMessage:(NSString *)text url:(NSString *)url type:(MessageType)type {
    if (url) {

        NSString *str = [text stringByAppendingString:url];
        Message *msg = [[Message alloc]init];
        msg.text = str;
        msg.type = type;
        
        MessageFrame *mf = [[MessageFrame alloc]init];
        mf.message = msg;
        [self.messageFrames addObject:mf];
        
        //把数据存入数据库
        [MessageCache addMessage:str type:type];

        
    } else {
        Message *msg = [[Message alloc]init];
        msg.text = text;
        msg.type = type;
        
        MessageFrame *mf = [[MessageFrame alloc]init];
        mf.message = msg;
        [self.messageFrames addObject:mf];

        [MessageCache addMessage:msg.text type:type];
    
    }

    [self.tableview reloadData];
    
    // 4.自动滚动表格到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
    [self.tableview scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)configUIAppearce {
    self.view.backgroundColor = [UIColor redColor];
}

#pragma mark - 手势实现方法
//长按分享
- (void) doLongPress:(UIGestureRecognizer *)gesture {
    NSLog(@"dolongPress:%@",contentStr);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享" message:@"是否分享" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [alert addAction:cancelAction];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"分享");
        //注意：分享到新浪微博、微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈等平台需要参考各自的集成方法
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMSHAREKEY
                                          shareText:contentStr
                                         shareImage:[UIImage imageNamed:@"LOGO_64x64"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToRenren,UMShareToDouban,UMShareToSms,nil]
                                           delegate:self];
        
        //设置默认分享内容
        [[UMSocialControllerService defaultControllerService] setShareText:contentStr shareImage:[UIImage imageNamed:@"icon"] socialUIDelegate:self];
        
        
    }];
    [alert addAction:shareAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//点击进入url
- (void) clickButton {
    
    NSURL *contentUrl = [NSURL URLWithString:contentURLStr];
    if (contentUrl) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"点击进入" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        [alert addAction:cancelAction];
        UIAlertAction *shareAction = [UIAlertAction actionWithTitle:contentURLStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"进入");
            
            //调用Safari
            [[UIApplication sharedApplication] openURL:contentUrl];
            
        }];
        [alert addAction:shareAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark 语音的实现

- (IBAction)soundvoice {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请直接长按按钮说话" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)doLongPress2:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"**********");
        
        [MBProgressHUD showSuccess:@"请说话"];

        
        bool ret = [_iFlySpeechUnderstander startListening];  //开始监听
        if (ret) {
            self.isCanceled = NO;
        } else {
           NSLog(@"启动识别失败!");
        }
        
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"&&&&&&&&&");
        [MBProgressHUD showSuccess:@"说话结束"];

        
        [_iFlySpeechUnderstander stopListening];   //结束监听，并开始识别
    } else {
        NSLog(@"操作失败~！");
    }
}


#pragma mark - IFlySpeechRecognizerDelegate
/**
* @fn      onVolumeChanged
* @brief   音量变化回调
* @param   volume      -[in] 录音的音量，音量范围1~100
* @see
*/
- (void) onVolumeChanged: (int)volume {
}

 /**
* @fn      onBeginOfSpeech
* @brief   开始识别回调
* @see
*/
- (void) onBeginOfSpeech {
 }
/**
* @fn      onEndOfSpeech
* @brief   停止录音回调
* @see
*/
- (void) onEndOfSpeech {

}

 /**
* @fn      onError
* @brief   识别结束回调
* @param   errorCode   -[out] 错误类，具体用法见IFlySpeechError
*/
- (void) onError:(IFlySpeechError *)error {
    NSString *text ;
    if (self.isCanceled) {
        text = @"识别取消";
//     } else if (error.errorCode == 0 ) {
//        if (_result.length== 0) {
//            text = @"无识别结果";
//        } else {
//             text = @"识别成功";
//        }
//     }else {
//        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
//        NSLog(@"%@",text);
//    }
    } else {
        text = @"识别错误";
    }
}
/**
* @fn      onResults
* @brief   识别结果回调
* @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
* @see
*/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast {
    NSArray * temp = [[NSArray alloc]init];
     NSString * str = [[NSString alloc]init];
    NSMutableString *result = [[NSMutableString alloc] init];
        NSDictionary *dic = results[0];
        for (NSString *key in dic) {
         [result appendFormat:@"%@",key];

    }
    NSLog(@"听写结果：%@",result);
    //---------讯飞语音识别JSON数据解析---------//
    NSError * error;
    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
     NSLog(@"data: %@",data);
    NSDictionary * dic_result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSArray * array_ws = [dic_result objectForKey:@"ws"];
    //遍历识别结果的每一个单词
    for (int i=0; i<array_ws.count; i++) {
        temp = [[array_ws objectAtIndex:i] objectForKey:@"cw"];
        NSDictionary * dic_cw = [temp objectAtIndex:0];
         str = [str  stringByAppendingString:[dic_cw objectForKey:@"w"]];
        NSLog(@"识别结果:%@",[dic_cw objectForKey:@"w"]);
    }
    NSLog(@"最终的识别结果:%@",str);
    //去掉识别结果最后的标点符号
    if ([str isEqualToString:@"。"] || [str isEqualToString:@"？"] || [str isEqualToString:@"！"]) {
        NSLog(@"末尾标点符号：%@",str);
    } else {
         self.inputView.text = str;
        NSLog(@"显示为：%@",str);
    }
    _result = str;
    
    [self inputMessage:_result url:nil type:0];
    
    [self replayWithText:_result];
    
}




//
//- (IBAction)soundvoice {
//    
//    //初始化语音识别控件
//    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
//    _iflyRecognizerView.delegate = self;
//    [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
//    //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
//    [_iflyRecognizerView setParameter:@"asrview.pcm " forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
//    //启动识别服务
//    [_iflyRecognizerView start];
//    
//    
////    _iflyrReco = [[IFlyRecognizerView alloc]initWithCenter:self.view.center];
////    _iflyrReco.delegate = self;
////    [_iflyrReco setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
////   // [_iflyrReco setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
////    //指定返回数据格式
////    [_iflyrReco setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
////    [_iflyrReco start];
//    
//}
//
///**
// *  识别结果返回代理
// *
// *  @param resultArray 识别结果
// *  @param isLast      最后一次结果
// */
//-(void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
//{
////    NSLog(@"*(*********************************");
////    NSMutableString *result = [[NSMutableString alloc] init];
////    NSDictionary *dic = [resultArray objectAtIndex:0];
////    
////    for (NSString *key in dic) {
////        [result appendFormat:@"%@",key];
////    }
////    
////   // NSLog(@"%@",result);
////    [self replayWithText:result];
////    [self inputMessage:result url:nil type:MessageTypeMe];
//    
//    /**
//     有界面，听写结果回调
//     resultArray：听写结果
//     isLast：表示最后一次
//     ****/
//    NSMutableString *result = [[NSMutableString alloc] init];
//    NSDictionary *dic = [resultArray objectAtIndex:0];
//    
//    for (NSString *key in dic) {
//        [result appendFormat:@"%@",key];
//    }
//    _inputView.text = [NSString stringWithFormat:@"%@%@",_inputView.text,result];
//    
//    
//}
///**
// *  识别会话错误返回代理
// *
// *  @param error 错误码
// */
//-(void)onError:(IFlySpeechError *)error
//{
//    NSLog(@"error ------------ %@",error);
//}
//
//
//
//

@end
