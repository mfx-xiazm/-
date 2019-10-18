//
//  RCSearchClientVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCSearchClientVC.h"
#import "RCMyClientCell.h"
#import "HXSearchBar.h"
#import "RCMyBrokerCell.h"
#import "RCMyStoreCell.h"
#import "RCChangePwdVC.h"
#import "RCMyStore.h"
#import "RCMyBroker.h"
#import "RCSearchClient.h"
#import "RCClientDetailVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "RCClientCodeView.h"
#import "RCGoHouseVC.h"

static NSString *const MyClientCell = @"MyClientCell";
static NSString *const MyBrokerCell = @"MyBrokerCell";
static NSString *const MyStoreCell = @"MyStoreCell";

@interface RCSearchClientVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 门店列表 */
@property(nonatomic,strong) NSMutableArray *results;
/* 搜索关键词 */
@property(nonatomic,copy) NSString *keyword;
/* 搜索到的结果条数 */
@property(nonatomic,copy) NSString *total;
@end

@implementation RCSearchClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
}
-(NSMutableArray *)results
{
    if (_results == nil) {
        _results = [NSMutableArray array];
    }
    return _results;
}
-(void)setUpNavBar
{
    HXSearchBar *search = [HXSearchBar searchBar];
    search.backgroundColor = UIColorFromRGB(0xf5f5f5);
    search.hxn_width = HX_SCREEN_WIDTH - 100;
    search.hxn_height = 32;
    search.layer.cornerRadius = 32/2.f;
    search.layer.masksToBounds = YES;
    search.delegate = self;
    
    self.navigationItem.titleView = search;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClickd) title:@"取消" font:[UIFont systemFontOfSize:15] titleColor:UIColorFromRGB(0xFF9F08) highlightedColor:UIColorFromRGB(0xFF9F08) titleEdgeInsets:UIEdgeInsetsZero];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyClientCell class]) bundle:nil] forCellReuseIdentifier:MyClientCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyBrokerCell class]) bundle:nil] forCellReuseIdentifier:MyBrokerCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyStoreCell class]) bundle:nil] forCellReuseIdentifier:MyStoreCell];
    
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
        [strongSelf getSearchDataListRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getSearchDataListRequest:NO];
    }];
}
#pragma mark -- 接口请求
/** 搜索列表 */
-(void)getSearchDataListRequest:(BOOL)isRefresh
{
    if (self.dataType == 1) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
        NSString *actionPath = nil;
        if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1 || [MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
            data[@"name"] = (self.keyword && self.keyword.length)?self.keyword:@"";
            actionPath = @"cus/cus/mechanism/findCustomerLike";
        }else{
            data[@"name"] = (self.keyword && self.keyword.length)?self.keyword:@"";
            actionPath = @"cus/cus/mechanism/myCustomerByLike";
        }
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
        [HXNetworkTool POST:HXRC_M_URL action:actionPath parameters:parameters success:^(id responseObject) {
            hx_strongify(weakSelf);
            if ([responseObject[@"code"] integerValue] == 0) {
                if (isRefresh) {
                    [strongSelf.tableView.mj_header endRefreshing];
                    strongSelf.pagenum = 1;
                    [strongSelf.results removeAllObjects];
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCSearchClient class] json:responseObject[@"data"]];
                    [strongSelf.results addObjectsFromArray:arrt];
                }else{
                    [strongSelf.tableView.mj_footer endRefreshing];
                    strongSelf.pagenum ++;
                    if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                        NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCSearchClient class] json:responseObject[@"data"]];
                        [strongSelf.results addObjectsFromArray:arrt];
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
    }else if (self.dataType == 2) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"queryName"] = (self.keyword && self.keyword.length)?self.keyword:@"";
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
        [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/organization/myAllAgent" parameters:parameters success:^(id responseObject) {
            hx_strongify(weakSelf);
            if ([responseObject[@"code"] integerValue] == 0) {
                if (isRefresh) {
                    strongSelf.total = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"page"][@"total"]];
                    [strongSelf.tableView.mj_header endRefreshing];
                    strongSelf.pagenum = 1;
                    [strongSelf.results removeAllObjects];
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyBroker class] json:responseObject[@"data"][@"page"][@"records"]];
                    [strongSelf.results addObjectsFromArray:arrt];
                }else{
                    [strongSelf.tableView.mj_footer endRefreshing];
                    strongSelf.pagenum ++;
                    if ([responseObject[@"data"][@"page"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"page"][@"records"]).count){
                        NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyBroker class] json:responseObject[@"data"][@"page"][@"records"]];
                        [strongSelf.results addObjectsFromArray:arrt];
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
    }else{
        // 搜索门店
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"keywords"] = (self.keyword && self.keyword.length)?self.keyword:@"";
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
        [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/organization/queryShopList" parameters:parameters success:^(id responseObject) {
            hx_strongify(weakSelf);
            if ([responseObject[@"code"] integerValue] == 0) {
                if (isRefresh) {
                    strongSelf.total = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shopNum"]];
                    [strongSelf.tableView.mj_header endRefreshing];
                    strongSelf.pagenum = 1;
                    [strongSelf.results removeAllObjects];
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyStore class] json:responseObject[@"data"][@"shopList"][@"records"]];
                    [strongSelf.results addObjectsFromArray:arrt];
                }else{
                    [strongSelf.tableView.mj_footer endRefreshing];
                    strongSelf.pagenum ++;
                    if ([responseObject[@"data"][@"shopList"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"shopList"][@"records"]).count){
                        NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyStore class] json:responseObject[@"data"][@"shopList"][@"records"]];
                        [strongSelf.results addObjectsFromArray:arrt];
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
}
/** 删除经纪人 */
-(void)deleteBrokerRequest:(NSString *)accUuid completedCall:(void(^)(BOOL))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accUuid"] = accUuid;
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/organization/deleteAgent" parameters:parameters success:^(id responseObject) {
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
    
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/organization/lockAgent" parameters:parameters success:^(id responseObject) {
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
    
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/organization/resetAgentPwd" parameters:parameters success:^(id responseObject) {
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
/** 重置门店管理人密码 */
-(void)resetStorePwdRequest:(NSString *)uuid completedCall:(void(^)(BOOL))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"uuid"] = uuid;
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/organization/resetmdPwd" parameters:parameters success:^(id responseObject) {
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
-(void)cancelClickd
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITextField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField hasText]) {
        self.keyword = textField.text;
    }else{
        self.keyword = @"";
    }
    [self getSearchDataListRequest:YES];
    return YES;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataType == 1) {
        RCMyClientCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCSearchClient *searchClient = self.results[indexPath.row];
        /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
        if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1 || [MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
            cell.remarkView.hidden = YES;
            cell.brokerView.hidden = YES;
            cell.mangeView.hidden = NO;
        }else{
            cell.remarkView.hidden = NO;
            cell.brokerView.hidden = NO;
            cell.mangeView.hidden = YES;
        }
        cell.searchClient = searchClient;
        
        hx_weakify(self);
        cell.clientHandleCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 1) {
                if (searchClient.isHidden) {
                    RCClientCodeView *codeView = [RCClientCodeView loadXibView];
                    codeView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 265.f);
                    codeView.closeBtnCall = ^{
                        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
                    };
                    strongSelf.zh_popupController = [[zhPopupController alloc] init];
                    strongSelf.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
                    [strongSelf.zh_popupController presentContentView:codeView duration:0.25 springAnimated:NO];
                }else{
                    RCGoHouseVC *hvc = [RCGoHouseVC new];
                    hvc.cusUuid = searchClient.cusUuid;
                    [strongSelf.navigationController pushViewController:hvc animated:YES];
                }
            }else if (index == 2) {
                if (searchClient.isHidden) {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"隐号报备"];
                }else{
                    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:searchClient.phone constantWidth:HX_SCREEN_WIDTH - 50*2];
                    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                        [strongSelf.zh_popupController dismiss];
                    }];
                    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"拨打" handler:^(zhAlertButton * _Nonnull button) {
                        [strongSelf.zh_popupController dismiss];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",searchClient.phone]]];
                    }];
                    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                    strongSelf.zh_popupController = [[zhPopupController alloc] init];
                    [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
                }
            }else if (index == 3) {
                if (searchClient.isHidden) {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"隐号报备"];
                }else{
                    NSString *phoneStr = [NSString stringWithFormat:@"%@",searchClient.phone];//发短信的号码
                    NSString *urlStr = [NSString stringWithFormat:@"sms://%@", phoneStr];
                    NSURL *url = [NSURL URLWithString:urlStr];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }else{
                RCClientDetailVC *dvc = [RCClientDetailVC  new];
                dvc.cusUuid = searchClient.cusUuid;
                [strongSelf.navigationController pushViewController:dvc animated:YES];
            }
        };
        return cell;
    }else if (self.dataType == 2){
        RCMyBrokerCell *cell = [tableView dequeueReusableCellWithIdentifier:MyBrokerCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCMyBroker *broker = self.results[indexPath.row];
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
                            [strongSelf.results removeObject:broker];
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
    }else{
        RCMyStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:MyStoreCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCMyStore *store = self.results[indexPath.row];
        cell.store = store;
        hx_weakify(self);
        cell.resetPwdCall = ^{
            hx_strongify(weakSelf);
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定重置为初始默认密码吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                [strongSelf.zh_popupController dismiss];
            }];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确定" handler:^(zhAlertButton * _Nonnull button) {
                [strongSelf.zh_popupController dismiss];
                [strongSelf resetStorePwdRequest:store.accuuid completedCall:^(BOOL isSuccess) {
                    
                }];
            }];
            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
            strongSelf.zh_popupController = [[zhPopupController alloc] init];
            [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
        };
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataType == 1) {
        /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
        if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1 || [MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
            return 160.f;
        }else{
            return 160.f+60.f;
        }
    }else if (self.dataType == 2){
        return 165.f;
    }else{
        return 160.f;
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 44.f;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc] init];
//    label.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44);
//    label.backgroundColor = HXGlobalBg;
//    label.textColor = [UIColor lightGrayColor];
//    label.font = [UIFont systemFontOfSize:13];
//    if (self.dataType == 1) {
//        label.text = [NSString stringWithFormat:@"   您搜索到%@个客户",self.total];
//    }else if (self.dataType == 2) {
//        label.text = [NSString stringWithFormat:@"   您搜索到%@个经纪人",self.total];
//    }else{
//        label.text = [NSString stringWithFormat:@"   您搜索到%@个门店",self.total];
//    }
//    return label;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataType == 1) {
        RCSearchClient *client = self.results[indexPath.row];
        RCClientDetailVC *dvc = [RCClientDetailVC  new];
        dvc.cusUuid = client.baoBeiUuid;
        dvc.remarkSuccessCall = ^(NSString * _Nonnull remarkTime, NSString * _Nonnull remark) {
            client.time = remarkTime;
            client.remark = remark;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:dvc animated:YES];
    }
}


@end
