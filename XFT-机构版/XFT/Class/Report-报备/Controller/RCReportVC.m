//
//  RCReportVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCReportVC.h"
#import "HXPlaceholderTextView.h"
#import "RCFilterCell.h"
#import "RCWishHouseVC.h"
#import "RCBatchReportVC.h"
#import "WSDatePickerView.h"
#import "RCReportPersonVC.h"
#import "RCReportResultVC.h"
#import "RCAddPhoneCell.h"
#import "RCHouseTagsCell.h"
#import <ZLCollectionViewHorzontalLayout.h>
#import "RCReportHouse.h"
#import "RCReporter.h"

static NSString *const FilterCell = @"FilterCell";
static NSString *const AddPhoneCell = @"AddPhoneCell";
static NSString *const HouseTagsCell = @"HouseTagsCell";

@interface RCReportVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UISwitch *hiddenSwitch;
@property (weak, nonatomic) IBOutlet UITextField *reportPersonName;
@property (weak, nonatomic) IBOutlet UIImageView *reportPersonRightImg;
@property (weak, nonatomic) IBOutlet UIView *reportPersonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reportPersonViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *sureReportBtn;
/* 选择的楼盘 */
@property(nonatomic,strong) NSMutableArray *selectHouses;
/* 是否允许隐号报备 默认允许 */
@property(nonatomic,assign) BOOL isAllowHidden;
/* 选中的那个报备人 */
@property(nonatomic,strong) RCReporter *selectReporter;
@end

@implementation RCReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"报备"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(batchReportClicked) title:@"批量报备" font:[UIFont systemFontOfSize:16] titleColor:UIColorFromRGB(0x333333) highlightedColor:UIColorFromRGB(0x333333) titleEdgeInsets:UIEdgeInsetsZero];
    self.isAllowHidden = YES;
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {//中介报备人可以选择其他
        self.reportPersonRightImg.hidden = NO;
    }else{//中介经纪人不可以选择其他，默认自己
        self.reportPersonRightImg.hidden = YES;
    }
    self.remark.placeholder = @"请输入补充说明(选填)";
    [self setUpCollectionView];
    
    hx_weakify(self);
    [self.sureReportBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (!strongSelf.selectHouses.count) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择意向楼盘"];
            return NO;
        }
        if (![strongSelf.name hasText]){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入客户姓名"];
            return NO;
        }
        if (![strongSelf.phone hasText]){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入客户电话"];
            return NO;
        }
        if (strongSelf.phone.text.length < 7){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"电话格式不对"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf reportSubmitClicked:button];
    }];
}
-(NSMutableArray *)selectHouses
{
    if (_selectHouses == nil) {
        _selectHouses = [NSMutableArray array];
    }
    return _selectHouses;
}
-(void)setUpCollectionView
{
    ZLCollectionViewHorzontalLayout *flowLayout = [[ZLCollectionViewHorzontalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseTagsCell class]) bundle:nil] forCellWithReuseIdentifier:HouseTagsCell];
}
#pragma mark -- 点击事件
- (void)batchReportClicked
{
    RCBatchReportVC *rvc = [RCBatchReportVC new];
    [self.navigationController pushViewController:rvc animated:YES];
}
- (IBAction)hiddenPersonPhoneClicked:(UISwitch *)sender {
    if (!self.isAllowHidden) {//存在楼盘不允许隐号报备
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"存在不允许隐号报备的楼盘"];
        self.hiddenSwitch.on = NO;
        return;
    }
    self.hiddenSwitch.on = !self.hiddenSwitch.isOn;//允许隐号报备，可以任意开关
}

- (IBAction)reportBtnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        RCWishHouseVC *hvc = [RCWishHouseVC new];
        hvc.isBatchReport = NO;
        if (self.selectHouses && self.selectHouses.count) {
            hvc.lastHouses = self.selectHouses;
        }
        hx_weakify(self);
        hvc.wishHouseCall = ^(NSArray * _Nonnull houses) {
            hx_strongify(weakSelf);
            strongSelf.selectHouses = [NSMutableArray arrayWithArray:houses];
            if (strongSelf.selectHouses.count) {
                strongSelf.houseViewHeight.constant = 50.f+60.f;
            }else{
                strongSelf.houseViewHeight.constant = 50.f;
            }
            for (RCReportHouse *house in strongSelf.selectHouses) {
                if (!house.isHeidi) {//存在不允许隐号报备的楼盘
                    strongSelf.isAllowHidden = NO;
                    strongSelf.hiddenSwitch.on = NO;
                    break;
                }
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
            });
        };
        [self.navigationController pushViewController:hvc animated:YES];
    }else{
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
}
- (void)reportSubmitClicked:(UIButton *)sender {
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    NSMutableArray *proIds = [NSMutableArray array];
    for (RCReportHouse *house in self.selectHouses) {
        [proIds addObject:house.uuid];
    }
    data[@"proIds"] = proIds;//项目列表 必填
    
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
    data[@"oneQudaoUuid"] = @"K-0017";//一级渠道id
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
    [self.selectHouses removeAllObjects];//清空选择楼盘
    self.houseViewHeight.constant = 50.f;
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView reloadData];
    });
    
    self.isAllowHidden = YES;//重置是否允许隐号报备
    self.name.text = nil;// 重置报备对象信息
    self.phone.text = nil;// 重置报备对象信息
    self.selectReporter = nil; // 重置报备人信息
    self.reportPersonName.text = nil;// 重置报备人信息
    self.remark.text = nil;//清空备注信息
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectHouses.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ColumnLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseTagsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:HouseTagsCell forIndexPath:indexPath];
    RCReportHouse *house = self.selectHouses[indexPath.item];
    cell.name.text = house.proName;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectHouses removeObjectAtIndex:indexPath.item];
    if (!self.selectHouses.count) {
        self.houseViewHeight.constant = 50.f;
    }else{
        self.houseViewHeight.constant = 50.f + 60.f;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [collectionView reloadData];
    });
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCReportHouse *house = self.selectHouses[indexPath.item];
    return CGSizeMake([house.proName boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 50, 30);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(15, 15, 15, 15);
}
@end
