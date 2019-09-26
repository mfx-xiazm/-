//
//  RCMyBrokerVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyBrokerVC.h"
#import "RCMyBrokerCell.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "RCSearchClientVC.h"
#import "RCAddBrokerVC.h"
#import "RCMyBroker.h"

static NSString *const MyBrokerCell = @"MyBrokerCell";

@interface RCMyBrokerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 经纪人列表 */
@property(nonatomic,strong) NSMutableArray *brokers;
/* 总数 */
@property(nonatomic,copy) NSString *total;
@end

@implementation RCMyBrokerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    [self getBrokerListDataRequest:YES];
}
-(NSMutableArray *)brokers
{
    if (_brokers == nil) {
        _brokers = [NSMutableArray array];
    }
    return _brokers;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"我的经纪人"];
    
    SPButton *filterItem = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    filterItem.hxn_size = CGSizeMake(44, 44);
    filterItem.imageTitleSpace = 5.f;
    filterItem.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [filterItem setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [filterItem setImage:HXGetImage(@"icon__top_add") forState:UIControlStateNormal];
    [filterItem addTarget:self action:@selector(addBrokerClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:filterItem];
    
    SPButton *searchItem = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    searchItem.hxn_size = CGSizeMake(44, 44);
    [searchItem setImage:HXGetImage(@"icon_search") forState:UIControlStateNormal];
    [searchItem addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:searchItem];
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
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
    self.tableView.estimatedRowHeight = 100;//预估高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyBrokerCell class]) bundle:nil] forCellReuseIdentifier:MyBrokerCell];
    
    self.tableView.hidden = YES;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getBrokerListDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getBrokerListDataRequest:NO];
    }];
}
#pragma mark -- 接口请求
/** 门店筛选列表 */
-(void)getBrokerListDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"queryName"] = @"";
    NSMutableDictionary *page = [NSMutableDictionary dictionary];
    if (isRefresh) {
        page[@"current"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        page[@"current"] = @(pagenum);//第几页
    }
    page[@"size"] = @"10";
    parameters[@"data"] = data;
    parameters[@"page"] = page;
    
    hx_weakify(self);
    [HXNetworkTool POST:@"http://192.168.200.21:9000/open/api/" action:@"agent/agent/organization/myAllAgent" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                strongSelf.total = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"page"][@"total"]];
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.brokers removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyBroker class] json:responseObject[@"data"][@"page"][@"records"]];
                [strongSelf.brokers addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"page"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"page"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyBroker class] json:responseObject[@"data"][@"page"][@"records"]];
                    [strongSelf.brokers addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tableView.hidden = NO;
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 删除经纪人 */
-(void)deleteBrokerRequest:(NSString *)accUuid completedCall:(void(^)(BOOL))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accUuid"] = accUuid;
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:@"http://192.168.200.21:9000/open/api/" action:@"agent/agent/organization/deleteAgent" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            completedCall(YES);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 解禁、禁用经纪人 */
-(void)lockBrokerRequest:(NSString *)accUuid completedCall:(void(^)(BOOL))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accUuid"] = accUuid;
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:@"http://192.168.200.21:9000/open/api/" action:@"agent/agent/organization/lockAgent" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            completedCall(YES);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 重置经纪人密码 */
-(void)resetBrokerPwdRequest:(NSString *)accUuid completedCall:(void(^)(BOOL))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accUuid"] = accUuid;
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:@"http://192.168.200.21:9000/open/api/" action:@"agent/agent/organization/resetAgentPwd" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            completedCall(YES);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
-(void)addBrokerClicked
{
    RCAddBrokerVC *bvc = [RCAddBrokerVC new];
    hx_weakify(self);
    bvc.addBrokerCall = ^{
        [weakSelf getBrokerListDataRequest:YES];
    };
    [self.navigationController pushViewController:bvc animated:YES];
}
-(void)searchClicked
{
    RCSearchClientVC *cvc = [RCSearchClientVC new];
    cvc.dataType = 2;
    [self.navigationController pushViewController:cvc animated:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.brokers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCMyBrokerCell *cell = [tableView dequeueReusableCellWithIdentifier:MyBrokerCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCMyBroker *broker = self.brokers[indexPath.row];
    cell.broker = broker;
    hx_weakify(self);
    cell.resetOrDeleteCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        if (index == 1) {
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:[broker.state isEqualToString:@"1"]?@"确定禁用经纪人吗？":@"确定解禁经纪人吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                [strongSelf.zh_popupController dismiss];
            }];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确定" handler:^(zhAlertButton * _Nonnull button) {
                [strongSelf.zh_popupController dismiss];
                [strongSelf lockBrokerRequest:broker.accUuid completedCall:^(BOOL isSuccess) {
                    if (isSuccess) {
                        broker.state = [broker.state isEqualToString:@"1"]?@"0":@"1";
                        [tableView reloadData];
                    }
                }];
            }];
            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
            strongSelf.zh_popupController = [[zhPopupController alloc] init];
            [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
        }else if (index == 2) {
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定删除该经纪人吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                [strongSelf.zh_popupController dismiss];
            }];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确定" handler:^(zhAlertButton * _Nonnull button) {
                [strongSelf.zh_popupController dismiss];
                [strongSelf deleteBrokerRequest:broker.accUuid completedCall:^(BOOL isSuccess) {
                    if (isSuccess) {
                        [strongSelf.brokers removeObject:broker];
                        [tableView reloadData];
                    }
                }];
            }];
            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:UIColorFromRGB(0xEC142D) forState:UIControlStateNormal];
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
            strongSelf.zh_popupController = [[zhPopupController alloc] init];
            [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
        }else{
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定重置为初始默认密码吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                [strongSelf.zh_popupController dismiss];
            }];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确定" handler:^(zhAlertButton * _Nonnull button) {
                [strongSelf.zh_popupController dismiss];
                [strongSelf resetBrokerPwdRequest:broker.accUuid completedCall:^(BOOL isSuccess) {
                    
                }];
            }];
            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
            strongSelf.zh_popupController = [[zhPopupController alloc] init];
            [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
        }
    };
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [UIView new];
    bgView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44);
    bgView.backgroundColor = HXGlobalBg;
  
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 0, HX_SCREEN_WIDTH/2.0, 44);
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.text = [NSString stringWithFormat:@"共%@个经纪人",self.total];
    [bgView addSubview:label];
    
    return bgView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
