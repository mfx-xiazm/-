//
//  RCWishHouseVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCWishHouseVC.h"
#import "RCWishHouseHeader.h"
#import "RCWishHouseFilterView.h"
#import "RCWishHouseCell.h"
#import "RCReportHouse.h"

static NSString *const WishHouseCell = @"WishHouseCell";

@interface RCWishHouseVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 筛选 */
@property(nonatomic,strong) RCWishHouseFilterView *filterView;
/* 头部视图 */
@property(nonatomic,strong) RCWishHouseHeader *header;
/* 选择的报备楼盘 */
@property(nonatomic,strong) NSMutableArray *reportHouses;
/* 罗盘列表 */
@property(nonatomic,strong) NSMutableArray *houses;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
@end

@implementation RCWishHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    [self queryHouseListRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 70);
}
-(void)setLastHouses:(NSArray *)lastHouses
{
    _lastHouses = lastHouses;
    [self.reportHouses addObjectsFromArray:_lastHouses];
}
-(NSMutableArray *)reportHouses
{
    if (_reportHouses == nil) {
        _reportHouses = [NSMutableArray array];
    }
    return _reportHouses;
}
-(NSMutableArray *)houses
{
    if (_houses == nil) {
        _houses = [NSMutableArray array];
    }
    return _houses;
}
-(RCWishHouseHeader *)header
{
    if (_header == nil) {
        _header = [RCWishHouseHeader loadXibView];
    }
    return _header;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"合作项目"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(sureClickd) title:@"确定" font:[UIFont systemFontOfSize:15] titleColor:UIColorFromRGB(0xFF9F08) highlightedColor:UIColorFromRGB(0xFF9F08) titleEdgeInsets:UIEdgeInsetsZero];
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
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCWishHouseCell class]) bundle:nil] forCellReuseIdentifier:WishHouseCell];
    
    self.tableView.tableHeaderView = self.header;
    
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
        [strongSelf queryHouseListRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf queryHouseListRequest:NO];
    }];
}
#pragma mark -- 接口请求
-(void)queryHouseListRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (isRefresh) {
        data[@"current"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        data[@"current"] = @(pagenum);//第几页
    }
    data[@"pageSize"] = @(10);
   
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/orgbaobei/queryOrgProperty" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.houses removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCReportHouse class] json:responseObject[@"data"][@"page"]];
                [strongSelf.houses addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"page"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"page"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCReportHouse class] json:responseObject[@"data"][@"page"]];
                    [strongSelf.houses addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleHouseData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleHouseData
{
    self.tableView.hidden = NO;
    
    self.header.houses = self.reportHouses;

    hx_weakify(self);
    self.header.delectHouseCall = ^{
        hx_strongify(weakSelf);
        [strongSelf checkSelectData];//移除之后再次去判断选中的情况
    };
    
    [self checkSelectData];
}
/** 判断列表罗盘选中的情况 */
-(void)checkSelectData
{
    for (RCReportHouse *house in self.houses) {
        house.isSelected = NO;
        for (RCReportHouse *selectHouse in self.reportHouses) {
            if ([house.uuid isEqualToString:selectHouse.uuid]) {
                house.isSelected = YES;
                break;
            }
        }
    }
    [self.tableView reloadData];
}
#pragma mark -- 点击事件
-(void)sureClickd
{
    if (!self.reportHouses.count) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择报备房源"];
        return;
    }
    if (self.wishHouseCall) {
        self.wishHouseCall(self.reportHouses);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.houses.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCWishHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:WishHouseCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCReportHouse *house = self.houses[indexPath.row];
    cell.house = house;
    hx_weakify(self);
    cell.selectHouseCall = ^{
        hx_strongify(weakSelf);
        if (house.isSelected) {
            house.isSelected = NO;
            for (RCReportHouse *selectHouse in strongSelf.reportHouses) {
                if ([house.uuid isEqualToString:selectHouse.uuid]) {
                    [strongSelf.reportHouses removeObject:selectHouse];
                    break;
                }
            }
        }else{
            if (strongSelf.isBatchReport) {// 批量报备只能选择一个
                if (strongSelf.reportHouses.count == 1) {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"只能选择一个楼盘"];
                    return;
                }
            }else{//单个报备最多三个
                if (strongSelf.reportHouses.count == 3) {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"最多选择三个楼盘"];
                    return;
                }
            }
            house.isSelected = YES;
            [strongSelf.reportHouses addObject:house];
        }
        strongSelf.header.houses = strongSelf.reportHouses;
        [strongSelf checkSelectData];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 95.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.filterView) {
        return self.filterView;
    }
    RCWishHouseFilterView *fv = [RCWishHouseFilterView loadXibView];
    fv.hxn_width = HX_SCREEN_WIDTH;
    fv.hxn_height = 50.f;
    self.filterView = fv;
    return fv;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
