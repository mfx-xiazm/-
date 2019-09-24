//
//  RCProfileInfoVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileInfoVC.h"
#import "FSActionSheet.h"

@interface RCProfileInfoVC ()<FSActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *infoView0;
@property (weak, nonatomic) IBOutlet UILabel *jgName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *bankOpen;
@property (weak, nonatomic) IBOutlet UILabel *bankNo;

@property (weak, nonatomic) IBOutlet UIView *infoView1;
@end

@implementation RCProfileInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"查看信息"];
}
-(void)handleProfileInfo
{
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1 || [MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        self.infoView0.hidden = NO;
        self.infoView1.hidden = YES;
        
    }else{
        self.infoView0.hidden = YES;
        self.infoView1.hidden = NO;
    }
}
-(IBAction)loginOutClicked:(UIButton *)sender
{
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"确定要退出登录吗" delegate:self cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"退出"]];
    //        hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        //            hx_strongify(weakSelf);
        if (selectedIndex == 1) {
            HXLog(@"退出");
        }
    }];
}

@end
