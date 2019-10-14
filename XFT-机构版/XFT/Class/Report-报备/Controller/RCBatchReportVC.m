//
//  RCBatchReportVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBatchReportVC.h"
#import "RCFilterCell.h"
#import "HXPlaceholderTextView.h"
#import "RCWishHouseVC.h"
#import "RCAddClientCell.h"
#import "WSDatePickerView.h"
#import "RCReportPersonVC.h"
#import "RCReportResultVC.h"
#import "RCHouseTagsCell.h"
#import <ZLCollectionViewHorzontalLayout.h>
#import "RCReportTarget.h"
#import "RCReportHouse.h"
#import "RCReporter.h"

static NSString *const FilterCell = @"FilterCell";
static NSString *const AddClientCell = @"AddClientCell";
static NSString *const HouseTagsCell = @"HouseTagsCell";

@interface RCBatchReportVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreClientViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *moreClientTableView;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UIView *reportPersonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reportPersonViewHeight;
@property (weak, nonatomic) IBOutlet UISwitch *hiddenSwitch;
@property (weak, nonatomic) IBOutlet UITextField *reportPersonName;
@property (weak, nonatomic) IBOutlet UIImageView *reportPersonRightImg;
@property (weak, nonatomic) IBOutlet UIButton *sureReportBtn;
/* 是否允许隐号报备 默认允许 */
@property(nonatomic,assign) BOOL isAllowHidden;
/* 批量选择只能选择一个楼盘 */
@property(nonatomic,strong) RCReportHouse *selectHouse;
/* 客户列表 */
@property(nonatomic,strong) NSMutableArray *clients;
/* 选中的那个报备人 */
@property(nonatomic,strong) RCReporter *selectReporter;
@end

@implementation RCBatchReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"批量报备"];
    self.remark.placeholder = @"请输入补充说明(选填)";
    self.isAllowHidden = YES;
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {//中介报备人可以选择其他
        self.reportPersonRightImg.hidden = NO;
    }else{//中介经纪人不可以选择其他，默认自己
        self.reportPersonRightImg.hidden = YES;
    }
    
    [self setUpTableView];
    [self setUpCollectionView];
    
    hx_weakify(self);
    [self.sureReportBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (!strongSelf.selectHouse) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择意向楼盘"];
            return NO;
        }
        for (RCReportTarget *person in strongSelf.clients) {
            if (person.cusName && person.cusName.length && person.cusPhone && person.cusPhone.length && person.cusPhone.length >= 7) {// 信息填写完全
                
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"客户信息不完整或者电话格式不对"];
                return NO;
                break;
            }
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf reportSubmitClicked:button];
    }];
}
-(NSMutableArray *)clients
{
    if (_clients == nil) {
        _clients = [NSMutableArray array];
        RCReportTarget *tar = [RCReportTarget new];
        [_clients addObject:tar];
    }
    return _clients;
}
-(void)setUpTableView
{
    self.moreClientTableView.estimatedSectionHeaderHeight = 0;
    self.moreClientTableView.estimatedSectionFooterHeight = 0;
    self.moreClientTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.moreClientTableView.scrollEnabled = NO;
    self.moreClientTableView.dataSource = self;
    self.moreClientTableView.delegate = self;
    self.moreClientTableView.showsVerticalScrollIndicator = NO;
    self.moreClientTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.moreClientTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCAddClientCell class]) bundle:nil] forCellReuseIdentifier:AddClientCell];
    
    self.moreClientViewHeight.constant = 110.f*self.clients.count;
    [self.moreClientTableView reloadData];
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
- (IBAction)reportBtnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        RCWishHouseVC *hvc = [RCWishHouseVC new];
        hvc.isBatchReport = YES;
        if (self.selectHouse) {
            hvc.lastHouses = @[self.selectHouse];
        }
        hx_weakify(self);
        hvc.wishHouseCall = ^(NSArray * _Nonnull houses) {
            hx_strongify(weakSelf);
            strongSelf.selectHouse = houses.firstObject;
            if (strongSelf.selectHouse) {
                strongSelf.houseViewHeight.constant = 50.f+60.f;
            }else{
                strongSelf.houseViewHeight.constant = 50.f;
            }
            if (!strongSelf.selectHouse.isHeidi) {//存在不允许隐号报备的楼盘
                strongSelf.isAllowHidden = NO;
                strongSelf.hiddenSwitch.on = NO;
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
- (IBAction)hiddenPersonPhoneClicked:(UISwitch *)sender {
    if (!self.isAllowHidden) {//存在楼盘不允许隐号报备
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"存在不允许隐号报备的楼盘"];
        self.hiddenSwitch.on = NO;
        return;
    }
    self.hiddenSwitch.on = !self.hiddenSwitch.isOn;//允许隐号报备，可以任意开关
}
- (void)reportSubmitClicked:(UIButton *)sender {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"proIds"] = @[self.selectHouse.uuid];//项目列表 必填
    
    NSMutableArray *cusInfo = [NSMutableArray array];
    for (RCReportTarget *person in self.clients) {
        [cusInfo addObject:@{@"name":person.cusName,//客户姓名
                             @"phone":@[self.hiddenSwitch.isOn?[NSString stringWithFormat:@"%@****%@",[person.cusPhone substringToIndex:3],[person.cusPhone substringFromIndex:person.cusPhone.length-4]]:person.cusPhone],//客户手机号
                             @"remark":[self.remark hasText]?self.remark.text:@"",//客户备注
                             @"twoQudaoName":([MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName && [MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName.length)?[MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName:@"",//报备人所属机构名称
                             @"twoQudaoCode":([MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgUuid && [MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgUuid.length)?[MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgUuid:@"",//报备人所属机构id
                             }];
    }
    data[@"cusInfo"] = cusInfo;//客户信息 必填
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
            [strongSelf clearBatchReportData];//清空页面数据
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
-(void)clearBatchReportData
{
    self.selectHouse = nil;//清空选择楼盘
    self.houseViewHeight.constant = 50.f;
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView reloadData];
    });
    
    self.isAllowHidden = YES;//重置是否允许隐号报备
    [self.clients removeAllObjects];// 清空报备对象信息
    RCReportTarget *tar = [RCReportTarget new];//加入第一个报备对象
    [self.clients addObject:tar];
    self.moreClientViewHeight.constant = 110.f*self.clients.count;
    [self.moreClientTableView reloadData];
    
    self.selectReporter = nil; // 重置报备人信息
    self.reportPersonName.text = nil;// 重置报备人信息
    self.remark.text = nil;//清空备注信息
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.clients.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCAddClientCell *cell = [tableView dequeueReusableCellWithIdentifier:AddClientCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCReportTarget *person = self.clients[indexPath.row];
    cell.person = person;
    if (indexPath.row == self.clients.count-1) {//最后一个
        [cell.addOrDelBtn setImage:HXGetImage(@"icon_add") forState:UIControlStateNormal];
    }else{
        [cell.addOrDelBtn setImage:HXGetImage(@"icon_del") forState:UIControlStateNormal];
    }
    hx_weakify(self);
    cell.cutBtnCall = ^{
        hx_strongify(weakSelf);
        if (indexPath.row == strongSelf.clients.count-1) {//最后一个
            RCReportTarget *person = [RCReportTarget new];
            [strongSelf.clients addObject:person];
        }else{
            [strongSelf.clients removeObject:person];
        }
        strongSelf.moreClientViewHeight.constant = 110.f*strongSelf.clients.count;
        [strongSelf.moreClientTableView reloadData];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 110.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectHouse ?1:0;
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
    cell.name.text = self.selectHouse.proName;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectHouse = nil;

    self.houseViewHeight.constant = 50.f;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [collectionView reloadData];
    });
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self.selectHouse.proName boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 50, 30);
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
