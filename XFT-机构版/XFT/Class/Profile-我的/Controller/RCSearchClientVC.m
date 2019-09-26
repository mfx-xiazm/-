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
    [self getSearchDataListRequest:YES];
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
        [HXNetworkTool POST:@"http://192.168.200.21:9000/open/api/" action:@"agent/agent/organization/myAllAgent" parameters:parameters success:^(id responseObject) {
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
        [HXNetworkTool POST:@"http://192.168.199.177:9000/open/api/" action:@"agent/agent/organization/queryShopList" parameters:parameters success:^(id responseObject) {
            hx_strongify(weakSelf);
            if ([responseObject[@"code"] integerValue] == 0) {
                if (isRefresh) {
                    strongSelf.total = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shopNum"]];
                    [strongSelf.tableView.mj_header endRefreshing];
                    strongSelf.pagenum = 1;
                    [strongSelf.results removeAllObjects];
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyStore class] json:responseObject[@"data"][@"shopList"]];
                    [strongSelf.results addObjectsFromArray:arrt];
                }else{
                    [strongSelf.tableView.mj_footer endRefreshing];
                    strongSelf.pagenum ++;
                    if ([responseObject[@"data"][@"shopList"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"shopList"]).count){
                        NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyStore class] json:responseObject[@"data"][@"shopList"]];
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
        cell.target = self;
        if (indexPath.row %2) {
            cell.remarkView.hidden = NO;
            cell.brokerView.hidden = NO;
            cell.mangeView.hidden = YES;
        }else{
            cell.remarkView.hidden = YES;
            cell.brokerView.hidden = YES;
            cell.mangeView.hidden = NO;
        }
        return cell;
    }else if (self.dataType == 2){
        RCMyBrokerCell *cell = [tableView dequeueReusableCellWithIdentifier:MyBrokerCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCMyBroker *broker = self.results[indexPath.row];
        cell.broker = broker;
        return cell;
    }else{
        RCMyStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:MyStoreCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCMyStore *store = self.results[indexPath.row];
        cell.store = store;
        hx_weakify(self);
        cell.resetPwdCall = ^{
            RCChangePwdVC *pvc = [RCChangePwdVC new];
            [weakSelf.navigationController pushViewController:pvc animated:YES];
        };
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataType == 1) {
        if (indexPath.row %2) {
            return 160.f+60.f;
        }else{
            return 160.f;
        }
    }else if (self.dataType == 2){
        return 165.f;
    }else{
        return 160.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44);
    label.backgroundColor = HXGlobalBg;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    if (self.dataType == 1) {
        label.text = @"   您搜索到2个客户";
    }else if (self.dataType == 2) {
        label.text = [NSString stringWithFormat:@"   您搜索到%@个经纪人",self.total];
    }else{
        label.text = [NSString stringWithFormat:@"   您搜索到%@个门店",self.total];
    }
    return label;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
