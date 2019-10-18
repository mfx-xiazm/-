//
//  RCHouseStyleVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseStyleVC.h"
#import "RCHouseStyleHeader.h"
#import "RCHouseStyleDetailCell.h"
#import "RCShareView.h"
#import <zhPopupController.h>
#import "RCHouseReportVC.h"
#import "zhAlertView.h"
#import "RCHouseLoanVC.h"
#import "RCHouseInfo.h"
#import "RCHouseDetail.h"

static NSString *const HouseStyleDetailCell = @"HouseStyleDetailCell";

@interface RCHouseStyleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 免费咨询视图 */
@property (weak, nonatomic) IBOutlet UIView *consultView;
/** 免费咨询+房源报备视图 */
@property (weak, nonatomic) IBOutlet UIView *reportView;
/* 头视图 */
@property(nonatomic,strong) RCHouseStyleHeader *header;
/* 户型详情 */
@property(nonatomic,strong) RCHouseInfo *houseInfo;
@end

@implementation RCHouseStyleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"户型详情"];
    [self setUpTableView];
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1 || [MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        self.reportView.hidden = YES;
        self.consultView.hidden = NO;
    }else{//中介经纪人不可以选择其他，默认自己
        self.reportView.hidden = NO;
        self.consultView.hidden = YES;
    }
    
    [self getHouseStyleDetailRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 220);
}
-(RCHouseStyleHeader *)header
{
    if (_header == nil) {
        _header = [RCHouseStyleHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 220);
        hx_weakify(self);
        _header.loanDetailCall = ^{
            RCHouseLoanVC *lvc = [RCHouseLoanVC new];
            [weakSelf.navigationController pushViewController:lvc animated:YES];
        };
    }
    return _header;
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseStyleDetailCell class]) bundle:nil] forCellReuseIdentifier:HouseStyleDetailCell];
    
    self.tableView.tableHeaderView = self.header;
    
    self.tableView.hidden = YES;
}
#pragma mark -- 点击事件
-(void)shareClicked
{
    RCShareView *share = [RCShareView loadXibView];
    share.hxn_width = HX_SCREEN_WIDTH;
    share.hxn_height = 260.f;
    hx_weakify(self);
    share.shareTypeCall = ^(NSInteger type, NSInteger index) {
        if (type == 1) {
            if (index == 1) {
                HXLog(@"微信好友");
            }else if (index == 2) {
                HXLog(@"朋友圈");
            }else{
                HXLog(@"链接");
            }
        }else{
            [weakSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:share duration:0.25 springAnimated:NO];
}
- (IBAction)reportClicked:(UIButton *)sender {
    RCHouseReportVC *rvc = [RCHouseReportVC new];
    rvc.houseDetail = self.houseDetail;
    [self.navigationController pushViewController:rvc animated:YES];
}
- (IBAction)consultClicked:(UIButton *)sender {
    hx_weakify(self);
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:self.houseDetail.salesTel constantWidth:HX_SCREEN_WIDTH - 50*2];
    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
    }];
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"拨打" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",strongSelf.houseDetail.salesTel]]];
    }];
    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
    self.zh_popupController = [[zhPopupController alloc] init];
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
}
#pragma mark -- 接口请求
-(void)getHouseStyleDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"uuid"] = self.uuid;
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/apartment/ByUuid" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.houseInfo = [RCHouseInfo yy_modelWithDictionary:responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.tableView.hidden = NO;
            strongSelf.header.houseInfo = strongSelf.houseInfo;
            [strongSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.houseInfo.picList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseStyleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseStyleDetailCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.picUrl = self.houseInfo.picList[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 260.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
