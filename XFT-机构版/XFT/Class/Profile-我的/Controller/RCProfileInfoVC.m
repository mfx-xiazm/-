//
//  RCProfileInfoVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileInfoVC.h"
#import "FSActionSheet.h"
#import "RCLoginVC.h"
#import "HXNavigationController.h"

@interface RCProfileInfoVC ()<FSActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *infoView0;
@property (weak, nonatomic) IBOutlet UILabel *jgName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *bankOpen;
@property (weak, nonatomic) IBOutlet UILabel *bankNo;
@property (weak, nonatomic) IBOutlet UILabel *legalName;
@property (weak, nonatomic) IBOutlet UILabel *legalPhone;
@property (weak, nonatomic) IBOutlet UILabel *licenseCode;

@property (weak, nonatomic) IBOutlet UIView *infoView1;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *jgName1;
@property (weak, nonatomic) IBOutlet UILabel *phone;

@end

@implementation RCProfileInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"查看信息"];
    
    self.infoView0.hidden = YES;
    self.infoView1.hidden = YES;
    
    [self getUserInfoRequest];
}
-(void)getUserInfoRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/organization/userDetail" parameters:@{} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            hx_strongify(weakSelf);
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleProfileInfo:responseObject[@"data"]];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleProfileInfo:(NSDictionary *)info
{
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1 || [MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        self.infoView0.hidden = NO;
        self.infoView1.hidden = YES;
        self.jgName.text = info[@"agentName"];
        self.userName.text = info[@"accNo"];
        self.licenseCode.text = [NSString stringWithFormat:@"%@",info[@"licenseCode"]];
        self.bankOpen.text = [NSString stringWithFormat:@"%@",info[@"bankOpen"]];
        self.bankNo.text = [NSString stringWithFormat:@"%@",info[@"bankAccNo"]];
        self.legalName.text = [NSString stringWithFormat:@"%@",info[@"legalName"]];
        self.legalPhone.text = [NSString stringWithFormat:@"%@",info[@"legalPhone"]];
    }else{
        self.infoView0.hidden = YES;
        self.infoView1.hidden = NO;
        
        self.account.text = [NSString stringWithFormat:@"%@",info[@"accNo"]];
        self.nick.text = [NSString stringWithFormat:@"%@",info[@"nick"]];
        self.jgName1.text = [NSString stringWithFormat:@"%@",info[@"affiliation"]];
        self.phone.text = [NSString stringWithFormat:@"%@",info[@"regPhone"]];
    }
}
-(IBAction)loginOutClicked:(UIButton *)sender
{
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"确定要退出登录吗" delegate:self cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"退出"]];
    //        hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        //            hx_strongify(weakSelf);
        if (selectedIndex == 0) {
            [[MSUserManager sharedInstance] logout:nil];
            
            RCLoginVC *lvc = [RCLoginVC new];
            HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:lvc];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            
            //推出主界面出来
            CATransition *ca = [CATransition animation];
            ca.type = @"movein";
            ca.duration = 0.5;
            [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
        }
    }];
}

@end
