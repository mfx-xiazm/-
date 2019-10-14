//
//  RCAddBrokerVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCAddBrokerVC.h"

@interface RCAddBrokerVC ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *anme;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *jgName;

@end

@implementation RCAddBrokerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"添加经纪人"];
    
    self.jgName.text = [MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName;
    
    hx_weakify(self);
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.userName hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入用户名"];
            return NO;
        }
        if (![strongSelf.anme hasText]){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入真实姓名"];
            return NO;
        }
        if (![strongSelf.phone hasText]){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入手机号码"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf addBrokerRequest:button];
    }];
}

-(void)addBrokerRequest:(UIButton *)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accNo"] = self.userName.text;
    data[@"name"] = self.anme.text;
    data[@"regPhone"] = self.phone.text;
    data[@"uuid"] = [MSUserManager sharedInstance].curUserInfo.agentLoginInside.uuid;
    
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/organization/addAgent" parameters:parameters success:^(id responseObject) {
        [sender stopLoading:@"确认提交" image:nil textColor:nil backgroundColor:nil];
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf.addBrokerCall) {
                    strongSelf.addBrokerCall();
                }
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        [sender stopLoading:@"确认提交" image:nil textColor:nil backgroundColor:nil];
    }];
}
@end
