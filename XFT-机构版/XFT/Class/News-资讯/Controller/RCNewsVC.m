//
//  RCNewsVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNewsVC.h"
#import "RCNewsCell.h"
#import "RCNewsDetailVC.h"
#import <JXCategoryView.h>
#import "RCHouseBannerHeader.h"
#import "RCHouseBanner.h"
#import "RCHouseNews.h"

static NSString *const NewsCell = @"NewsCell";
@interface RCNewsVC ()<UITableViewDelegate,UITableViewDataSource,JXCategoryViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 切换控制器 */
@property (strong, nonatomic) JXCategoryTitleView *categoryView;
/* 头部视图 */
@property(nonatomic,strong) RCHouseBannerHeader *header;
/* 轮播图 */
@property(nonatomic,strong) NSArray *banners;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 资讯列表 */
@property(nonatomic,strong) NSMutableArray *newsList;
@end

@implementation RCNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"资讯"];
    [self setUpTableView];
    [self setUpRefresh];
    [self getNewsDataRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 10.f+170.f);
}
-(JXCategoryTitleView *)categoryView
{
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.frame = CGRectMake(0, 60.f-44.f, HX_SCREEN_WIDTH, 44);
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.titleLabelZoomEnabled = YES;
        _categoryView.titles = @[@"楼盘动态"];
        _categoryView.titleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _categoryView.cellSpacing = 45.f;
        _categoryView.contentEdgeInsetLeft = 20.f;
        _categoryView.titleColor = UIColorFromRGB(0x666666);
        _categoryView.titleSelectedColor = UIColorFromRGB(0x333333);
        _categoryView.delegate = self;
    }
    return _categoryView;
}
-(RCHouseBannerHeader *)header
{
    if (_header == nil) {
        _header = [RCHouseBannerHeader loadXibView];
        //hx_weakify(self);
        _header.bannerClickCall = ^(NSInteger index) {
            /*展现方式 0:不跳转 1:新闻咨询 2:报名活动 3房源详情 4:外链H5 5:城市公告 6:视频播放*/
        };
    }
    return _header;
}
-(NSMutableArray *)newsList
{
    if (_newsList == nil) {
        _newsList = [NSMutableArray array];
    }
    return _newsList;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCNewsCell class]) bundle:nil] forCellReuseIdentifier:NewsCell];
    
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
        [strongSelf getNewsListDataRequest:YES completeCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getNewsListDataRequest:NO completeCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
}
#pragma mark -- 接口请求
/** 资讯数据请求 */
-(void)getNewsDataRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"cityId"] = [RCUserAeraManager sharedInstance].curUserArea.cid;
        NSMutableDictionary *page = [NSMutableDictionary dictionary];
        page[@"current"] = @"1";
        page[@"size"] = @"10";
        parameters[@"data"] = data;
        parameters[@"page"] = page;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"marketing/marketing/xcxBanner/bannerList" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.banners = [NSArray yy_modelArrayWithClass:[RCHouseBanner class] json:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);
            
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
            
        }];
    });
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [strongSelf getNewsListDataRequest:YES completeCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        // 执行顺序10
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新界面
            hx_strongify(weakSelf);
            strongSelf.tableView.hidden = NO;
            strongSelf.header.banners = strongSelf.banners;
            [strongSelf.tableView reloadData];
        });
    });
}

/** 资讯列表请求 */
-(void)getNewsListDataRequest:(BOOL)isRefresh completeCall:(void(^)(void))completeCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"uuid"] = [RCUserAeraManager sharedInstance].curUserArea.cid;
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
    [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/News/findListByCityId" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.newsList removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCHouseNews class] json:responseObject[@"data"]];
                [strongSelf.newsList addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCHouseNews class] json:responseObject[@"data"]];
                    [strongSelf.newsList addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            if (completeCall) {
                completeCall();
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        if (completeCall) {
            completeCall();
        }
    }];
}
#pragma mark -- UITableView数据源和代理
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor whiteColor];
    header.hxn_height = 60.f;
    header.hxn_width = HX_SCREEN_WIDTH;
    [header addSubview:self.categoryView];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCHouseNews *news = self.newsList[indexPath.row];
    cell.news = news;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 130.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCNewsDetailVC *dvc = [RCNewsDetailVC new];
    RCHouseNews *news = self.newsList[indexPath.row];
    dvc.newsUuid = news.uuid;
    [self.navigationController pushViewController:dvc animated:YES];
}
@end
