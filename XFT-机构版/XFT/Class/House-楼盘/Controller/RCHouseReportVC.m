//
//  RCHouseReportVC.m
//  XFT
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseReportVC.h"
#import "RCReportHouse.h"
#import "RCReporter.h"
#import "HXPlaceholderTextView.h"
#import "RCHouseDetail.h"
#import "RCReportPersonVC.h"
#import "RCReportResultVC.h"

@interface RCHouseReportVC ()
@property (weak, nonatomic) IBOutlet UILabel *houseName;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UISwitch *hiddenSwitch;
@property (weak, nonatomic) IBOutlet UITextField *reportPersonName;
@property (weak, nonatomic) IBOutlet UIImageView *reportPersonRightImg;
@property (weak, nonatomic) IBOutlet UIButton *sureReportBtn;
/* 选中的那个报备人 */
@property(nonatomic,strong) RCReporter *selectReporter;
@end

@implementation RCHouseReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"报备"];

    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {//中介报备人可以选择其他
        self.reportPersonRightImg.hidden = NO;
    }else{//中介经纪人不可以选择其他，默认自己
        self.reportPersonRightImg.hidden = YES;
    }
    self.remark.placeholder = @"请输入补充说明(选填)";
    self.houseName.text = self.houseDetail.name;
    hx_weakify(self);
    [self.sureReportBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.name hasText]){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入客户姓名"];
            return NO;
        }
        if (![strongSelf.phone hasText]){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入客户电话"];
            return NO;
        }
        if ([strongSelf.phone.text hasPrefix:@"1"]){//如果以”1“开头就限制11位
            if (strongSelf.phone.text.length != 11) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机号码格式错误"];
                return NO;
            }
        }else{
            if (strongSelf.phone.text.length < 7) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"电话格式错误"];
                return NO;
            }
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf reportSubmitClicked:button];
    }];
}
#pragma mark -- 点击事件
- (IBAction)hiddenPersonPhoneClicked:(UISwitch *)sender {
    if (!self.houseDetail.isAllowHidden) {//存在楼盘不允许隐号报备
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"该楼盘不允许隐号报备"];
        self.hiddenSwitch.on = NO;
        return;
    }
    self.hiddenSwitch.on = !self.hiddenSwitch.isOn;//允许隐号报备，可以任意开关
}

- (IBAction)reportBtnClicked:(UIButton *)sender {
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {//中介报备人可以选择其他
        RCReportPersonVC *pvc = [RCReportPersonVC new];
        if (self.selectReporter) {
            pvc.selectReporter = self.selectReporter;
        }
        hx_weakify(self);
        pvc.selectReporterCall = ^(RCReporter * _Nonnull reporter) {
            hx_strongify(weakSelf);
            strongSelf.selectReporter = reporter;
            strongSelf.reportPersonName.text = reporter.shopname;
        };
        [self.navigationController pushViewController:pvc animated:YES];
    }else{//中介经纪人不可以选择其他，默认自己
        
    }
}
- (void)reportSubmitClicked:(UIButton *)sender {
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    data[@"proIds"] = @[self.houseDetail.uuid];//项目列表 必填
    
    data[@"cusInfo"] = @[@{@"name":self.name.text,//客户姓名
                           @"phone":@[self.hiddenSwitch.isOn?[NSString stringWithFormat:@"%@****%@",[self.phone.text substringToIndex:3],[self.phone.text substringFromIndex:self.phone.text.length-4]]:self.phone.text],//客户手机号
                           @"remark":[self.remark hasText]?self.remark.text:@"",//客户备注
                           @"twoQudaoName":([MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName && [MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName.length)?[MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName:@"",//报备人所属机构名称
                           @"twoQudaoCode":([MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgUuid && [MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgUuid.length)?[MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgUuid:@"",//报备人所属机构id
                           }
                         ];//客户信息 必填
    if (self.selectReporter) {//选择了其他门店的人
        data[@"accUuid"] = self.selectReporter.accMuuid;//报备人id 必填
        data[@"accName"] = self.selectReporter.accMname;//报备人名称
        if (self.selectReporter.orgname && self.selectReporter.orgname.length) {
            data[@"accTeamName"] = self.selectReporter.orgname;//归属机构名称
        }else{
            data[@"accTeamName"] = @"";//归属机构名称
        }
        if (self.selectReporter.orguuid && self.selectReporter.orguuid.length) {
            data[@"accTeamUuid"] = self.selectReporter.orguuid;//归属机构uuid
        }else{
            data[@"accTeamUuid"] = @"";//归属机构uuid
        }
        if (self.selectReporter.shopuuid && self.selectReporter.shopuuid.length) {
            data[@"accGroupUuid"] = self.selectReporter.shopuuid;//归属门店uuid
        }else{
            data[@"accGroupUuid"] = @"";//归属门店uuid
        }
        if (self.selectReporter.shopname && self.selectReporter.shopname.length) {
            data[@"accGroupName"] = self.selectReporter.shopname;//归属门店名称
        }else{
            data[@"accGroupName"] = @"";//归属门店名称
        }
        data[@"accType"] = @"6";//报备人类型 1 顾问 2 经纪人 3 自渠专员 4 展厅专员  5 统一报备人 6 门店管理员
    }else{// 未选择，也就是默认自己
        data[@"accUuid"] = [MSUserManager sharedInstance].curUserInfo.agentLoginInside.uuid;//报备人id 必填
        data[@"accName"] = [MSUserManager sharedInstance].curUserInfo.agentLoginInside.name;//报备人名称
        if ([MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName && [MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName.length) {
            data[@"accTeamName"] = [MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName;//归属机构名称
        }else{
            data[@"accTeamName"] = @"";//归属机构名称
        }
        if ([MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgUuid && [MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgUuid.length) {
            data[@"accTeamUuid"] = [MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgUuid;//归属机构uuid
        }else{
            data[@"accTeamUuid"] = @"";//归属机构uuid
        }
        if ([MSUserManager sharedInstance].curUserInfo.orgUserInfo.shopUuid && [MSUserManager sharedInstance].curUserInfo.orgUserInfo.shopUuid.length) {
            data[@"accGroupUuid"] = [MSUserManager sharedInstance].curUserInfo.orgUserInfo.shopUuid;//归属门店uuid
        }else{
            data[@"accGroupUuid"] = @"";//归属门店uuid
        }
        if ([MSUserManager sharedInstance].curUserInfo.orgUserInfo.shopName && [MSUserManager sharedInstance].curUserInfo.orgUserInfo.shopName.length) {
            data[@"accGroupName"] = [MSUserManager sharedInstance].curUserInfo.orgUserInfo.shopName;//归属门店名称
        }else{
            data[@"accGroupName"] = @"";//归属门店名称
        }
        if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {//中介报备人可以选择其他
            data[@"accType"] = @"5";//报备人类型 1 顾问 2 经纪人 3 自渠专员 4 展厅专员  5 统一报备人 6 门店管理员
        }else{//中介经纪人
            data[@"accType"] = @"2";//报备人类型 1 顾问 2 经纪人 3 自渠专员 4 展厅专员  5 统一报备人 6 门店管理员
        }
    }
    data[@"userRole"] = @([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole);//报备人角色 必填
    data[@"oneQudaoCode"] = @"K-0017";//一级渠道id
    data[@"oneQudaoName"] = @"中介";//一级渠道名称
    data[@"isHidePhone"] = self.hiddenSwitch.isOn?@"1":@"0";//是否隐号报备 0 否 1 是
    data[@"remark"] = [self.remark hasText]?self.remark.text:@"";//备注信息
    
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/cusbaobeilist/addReportCust" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"报备" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            [strongSelf clearReportData];// 报备结束清空页面数据
            RCReportResultVC *rvc = [RCReportResultVC new];
            rvc.results = responseObject[@"data"];
            [strongSelf.navigationController pushViewController:rvc animated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        [sender stopLoading:@"报备" image:nil textColor:nil backgroundColor:nil];
    }];
}
-(void)clearReportData
{
    self.name.text = nil;// 重置报备对象信息
    self.phone.text = nil;// 重置报备对象信息
    self.selectReporter = nil; // 重置报备人信息
    self.reportPersonName.text = nil;// 重置报备人信息
    self.remark.text = nil;//清空备注信息
}
@end
