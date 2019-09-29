//
//  RCLoginVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCLoginVC.h"
#import "RCWebContentVC.h"
#import "HXTabBarController.h"

@interface RCLoginVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *agreeMentTV;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation RCLoginVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HXControlBg;
    [self setAgreeMentProtocol];
    
    hx_weakify(self);
    [self.loginBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.account hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入账号"];
            return NO;
        }
        if (![strongSelf.pwd hasText]){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入密码"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf loginBtnClicked:button];
    }];
}

-(void)setAgreeMentProtocol
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"登录即代表同意《幸福通用户协议》和《幸福通隐私协议》"];
    [attributedString addAttribute:NSLinkAttributeName value:@"yhxy://" range:[[attributedString string] rangeOfString:@"《幸福通用户协议》"]];
    [attributedString addAttribute:NSLinkAttributeName value:@"ysxy://" range:[[attributedString string] rangeOfString:@"《幸福通隐私协议》"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFFFFF) range:NSMakeRange(0, attributedString.length)];
    
    _agreeMentTV.attributedText = attributedString;
    _agreeMentTV.linkTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f weight:UIFontWeightBold],NSUnderlineColorAttributeName: UIColorFromRGB(0xFFFFFF),NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    _agreeMentTV.delegate = self;
    _agreeMentTV.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
    _agreeMentTV.scrollEnabled = NO;
    _agreeMentTV.textAlignment = NSTextAlignmentCenter;
}

- (void)loginBtnClicked:(UIButton *)sender {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accNo"] = self.account.text;
    data[@"pwd"] = self.pwd.text;

    parameters[@"data"] = data;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/myAgent/institutionsLogin" parameters:parameters success:^(id responseObject) {
        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            
            MSUserInfo *userInfo = [MSUserInfo yy_modelWithDictionary:responseObject[@"data"]];
            [MSUserManager sharedInstance].curUserInfo = userInfo;
            [[MSUserManager sharedInstance] saveUserInfo];
            
            HXTabBarController *tab = [[HXTabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tab;
            
            //推出主界面出来
            CATransition *ca = [CATransition animation];
            ca.type = @"movein";
            ca.duration = 0.5;
            [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
    }];
}
- (IBAction)resetPwdClicked:(UIButton *)sender {
    HXLog(@"重置密码");
}

#pragma mark -- UITextView代理
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"yhxy"]) {
        RCWebContentVC *wvc = [RCWebContentVC new];
        wvc.navTitle = @"幸福通用户协议";
        wvc.url = @"https://www.baidu.com/";
        [self.navigationController pushViewController:wvc animated:YES];
        return NO;
    }else if ([[URL scheme] isEqualToString:@"ysxy"]) {
        RCWebContentVC *wvc = [RCWebContentVC new];
        wvc.navTitle = @"幸福通隐私协议";
        wvc.url = @"https://www.baidu.com/";
        [self.navigationController pushViewController:wvc animated:YES];
        return NO;
    }
    return YES;
}

@end
