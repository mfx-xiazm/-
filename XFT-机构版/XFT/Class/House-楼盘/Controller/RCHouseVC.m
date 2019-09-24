//
//  RCHouseVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseVC.h"
#import "RCHouseCell.h"
#import "RCHouseFilterView.h"
#import "RCHouseBannerHeader.h"
#import "RCSearchCityVC.h"
#import "RCSearchHouseVC.h"
#import "RCHouseDetailVC.h"
#import "YCMenuView.h"
#import "RCHouseBanner.h"
#import "RCHouseFilterData.h"
#import "RCHouseList.h"

static NSString *const HouseCell = @"HouseCell";

@interface RCHouseVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 筛选 */
@property(nonatomic,strong) RCHouseFilterView *filterView;
/* 头部视图 */
@property(nonatomic,strong) RCHouseBannerHeader *header;
/* 定位按钮 */
@property(nonatomic,strong) SPButton *locationBtn;
/* 轮播图 */
@property(nonatomic,strong) NSArray *banners;
/* 筛选数据 */
@property(nonatomic,strong) RCHouseFilterData *filterData;
/* 行政区域 */
@property(nonatomic,copy) NSString *countryUuid;
/* 物业类型 */
@property(nonatomic,copy) NSString *buldType;
/* 户型 */
@property(nonatomic,copy) NSString *hxType;
/* 建筑面积 */
@property(nonatomic,copy) NSString *areaType;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 房源列表 */
@property(nonatomic,strong) NSMutableArray *houses;
@end

@implementation RCHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    [self getCityRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 10.f+170.f);
}
-(void)setCountryUuid:(NSString *)countryUuid
{
    if (![_countryUuid isEqualToString:countryUuid]) {
        _countryUuid = countryUuid;
        hx_weakify(self);
        [self getHouseListDataRequest:YES completeCall:^{
            [weakSelf.tableView reloadData];
            // 不足筛选的一屏的时候，手动设置滑动范围
            CGFloat contentHeight = weakSelf.view.hxn_height + (10.f+170.f);
            if (weakSelf.tableView.contentSize.height < contentHeight) {
                weakSelf.tableView.contentSize = CGSizeMake(HX_SCREEN_WIDTH, contentHeight);
            }
        }];
    }
}
-(void)setBuldType:(NSString *)buldType
{
    if (![_buldType isEqualToString:buldType]) {
        _buldType = buldType;
        hx_weakify(self);
        [self getHouseListDataRequest:YES completeCall:^{
            [weakSelf.tableView reloadData];
            // 不足筛选的一屏的时候，手动设置滑动范围
            CGFloat contentHeight = weakSelf.view.hxn_height + (10.f+170.f);
            if (weakSelf.tableView.contentSize.height < contentHeight) {
                weakSelf.tableView.contentSize = CGSizeMake(HX_SCREEN_WIDTH, contentHeight);
            }
        }];
    }
}
-(void)setHxType:(NSString *)hxType
{
    if (![_hxType isEqualToString:hxType]) {
        _hxType = hxType;
        hx_weakify(self);
        [self getHouseListDataRequest:YES completeCall:^{
            [weakSelf.tableView reloadData];
            // 不足筛选的一屏的时候，手动设置滑动范围
            CGFloat contentHeight = weakSelf.view.hxn_height + (10.f+170.f);
            if (weakSelf.tableView.contentSize.height < contentHeight) {
                weakSelf.tableView.contentSize = CGSizeMake(HX_SCREEN_WIDTH, contentHeight);
            }
        }];
    }
}
-(void)setAreaType:(NSString *)areaType
{
    if (![_areaType isEqualToString:areaType]) {
        _areaType = areaType;
        hx_weakify(self);
        [self getHouseListDataRequest:YES completeCall:^{
            [weakSelf.tableView reloadData];
            // 不足筛选的一屏的时候，手动设置滑动范围
            CGFloat contentHeight = weakSelf.view.hxn_height + (10.f+170.f);
            if (weakSelf.tableView.contentSize.height < contentHeight) {
                weakSelf.tableView.contentSize = CGSizeMake(HX_SCREEN_WIDTH, contentHeight);
            }
        }];
    }
}
-(NSMutableArray *)houses
{
    if (_houses == nil) {
        _houses = [NSMutableArray array];
    }
    return _houses;
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
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    SPButton *item = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    item.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    item.hxn_size = CGSizeMake(150, 30);
    item.imageTitleSpace = 5.f;
    item.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [item setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [item setImage:HXGetImage(@"icon_home_place") forState:UIControlStateNormal];
    [item setTitle:@"武汉" forState:UIControlStateNormal];
    [item addTarget:self action:@selector(cityClicked) forControlEvents:UIControlEventTouchUpInside];
    self.locationBtn = item;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchClicked) nomalImage:HXGetImage(@"icon_search") higeLightedImage:HXGetImage(@"icon_search") imageEdgeInsets:UIEdgeInsetsZero];
    
    /*
    SPButton *menu = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
    menu.hxn_size = CGSizeMake(150 , 44);
    menu.imageTitleSpace = 5.f;
    menu.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [menu setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    [menu setTitle:@"文旅展厅" forState:UIControlStateNormal];
    [menu setImage:HXGetImage(@"Shape") forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = menu;
     */
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
    self.tableView.estimatedRowHeight = 120;//预估高度
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseCell class]) bundle:nil] forCellReuseIdentifier:HouseCell];
    
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
        [strongSelf getHouseListDataRequest:YES completeCall:^{
            [strongSelf.tableView reloadData];
            // 不足筛选的一屏的时候，手动设置滑动范围
            CGFloat contentHeight = weakSelf.view.hxn_height + (10.f+170.f);
            if (weakSelf.tableView.contentSize.height < contentHeight) {
                weakSelf.tableView.contentSize = CGSizeMake(HX_SCREEN_WIDTH, contentHeight);
            }
        }];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getHouseListDataRequest:NO completeCall:^{
            [strongSelf.tableView reloadData];
            // 不足筛选的一屏的时候，手动设置滑动范围
            CGFloat contentHeight = weakSelf.view.hxn_height + (10.f+170.f);
            if (weakSelf.tableView.contentSize.height < contentHeight) {
                weakSelf.tableView.contentSize = CGSizeMake(HX_SCREEN_WIDTH, contentHeight);
            }
        }];
    }];
}
#pragma mark -- 点击事件
-(void)menuClicked:(SPButton *)menuBtn
{
    YCMenuAction *action = [YCMenuAction actionWithTitle:@"融创西南展厅" image:nil handler:^(YCMenuAction *action) {
        [menuBtn setTitle:action.title forState:UIControlStateNormal];
        [menuBtn layoutSubviews];
    }];
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"融创西北展厅" image:nil handler:^(YCMenuAction *action) {
        [menuBtn setTitle:action.title forState:UIControlStateNormal];
        [menuBtn layoutSubviews];
    }];
    
    YCMenuView *view = [YCMenuView menuWithActions:@[action,action1] width:140 atPoint:CGPointMake(HX_SCREEN_WIDTH/2.0, self.HXNavBarHeight)];
    view.currentText = menuBtn.currentTitle;
    view.currentTextColor = HXControlBg;
    view.isShowShadow = NO;
    // 显示
    [view show];
}
-(void)cityClicked
{
    RCSearchCityVC *hvc = [RCSearchCityVC new];
    hx_weakify(self);
    hvc.changeCityCall = ^{
        [weakSelf.locationBtn setTitle:[NSString stringWithFormat:@"%@-%@",[RCUserAeraManager sharedInstance].curUserArea.cname,[RCUserAeraManager sharedInstance].curUserArea.aname] forState:UIControlStateNormal];
        // 清空筛选条件
        weakSelf.countryUuid = nil;
        weakSelf.buldType = nil;
        weakSelf.hxType = nil;
        weakSelf.areaType = nil;
        weakSelf.filterView.areaLabel.text = @"行政区域";
        weakSelf.filterView.wuyeLabel.text = @"物业类型";
        weakSelf.filterView.huxingLabel.text = @"户型";
        weakSelf.filterView.mianjiLabel.text = @"面积";
        [weakSelf getCityRequest];//刷新数据
    };
    [self.navigationController pushViewController:hvc animated:YES];
}
-(void)searchClicked
{
    RCSearchHouseVC *hvc = [RCSearchHouseVC new];
    [self.navigationController pushViewController:hvc animated:YES];
}
#pragma mark -- 接口请求
/** 城市模糊查询列表 */
-(void)getCityRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if ([[RCUserAeraManager sharedInstance] loadUserArea]) {
        data[@"name"] = [RCUserAeraManager sharedInstance].curUserArea.cname;
    }else{
        data[@"name"] = @"武汉";
    }
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/city/cityByLike" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            RCUserArea *area = [RCUserArea yy_modelWithDictionary:responseObject[@"data"][0]];
            [RCUserAeraManager sharedInstance].curUserArea = area;
            [[RCUserAeraManager sharedInstance] saveUserArea];
            [weakSelf.locationBtn setTitle:[NSString stringWithFormat:@"%@-%@",area.cname,area.aname] forState:UIControlStateNormal];
            [weakSelf getHouseDataRequest];//根据城市ID请求数据
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 轮播图列表查询 筛选条件查询*/
-(void)getHouseDataRequest
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
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"cityUuid"] = [RCUserAeraManager sharedInstance].curUserArea.cid;
        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/dict/dictalllist" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.filterData = [RCHouseFilterData yy_modelWithDictionary:responseObject[@"data"]];
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
        [strongSelf getHouseListDataRequest:YES completeCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });

    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序8
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        // 执行顺序10
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新界面
            hx_strongify(weakSelf);
            strongSelf.tableView.hidden = NO;
            strongSelf.header.banners = strongSelf.banners;
            [strongSelf.tableView reloadData];
            
            // 不足筛选的一屏的时候，手动设置滑动范围
            CGFloat contentHeight = self.view.hxn_height + (10.f+170.f);
            if (self.tableView.contentSize.height < contentHeight) {
                self.tableView.contentSize = CGSizeMake(HX_SCREEN_WIDTH, contentHeight);
            }
        });
    });
}
/** 房源筛选列表 */
-(void)getHouseListDataRequest:(BOOL)isRefresh completeCall:(void(^)(void))completeCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"cityId"] = [RCUserAeraManager sharedInstance].curUserArea.cid;
    data[@"areaType"] = (self.areaType && self.areaType.length) ?self.areaType:@"";
    data[@"buldType"] = (self.buldType && self.buldType.length) ?self.buldType:@"";
    data[@"countryUuid"] = (self.countryUuid && self.countryUuid.length) ?self.countryUuid:@"";
    data[@"hxType"] = (self.hxType && self.hxType.length) ?self.hxType:@"";
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
    [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/proBaseInfo/proListByLike" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.houses removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCHouseList class] json:responseObject[@"data"][@"records"]];
                [strongSelf.houses addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCHouseList class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.houses addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        if (completeCall) {
            completeCall();
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        if (completeCall) {
            completeCall();
        }
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.houses.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCHouseList *house = self.houses[indexPath.row];
    cell.house = house;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 120.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.filterView) {
        self.filterView.target = self;
        self.filterView.tableView = tableView;
        self.filterView.filterData = self.filterData;
        hx_weakify(self);
        self.filterView.HouseFilterCall = ^(NSInteger btnTag, NSInteger index) {
            if (btnTag == 1) {
                RCHouseFilterDistrict *dus = weakSelf.filterData.countryList[index];
                weakSelf.countryUuid = dus.uuid;
            }else if (btnTag == 2) {
                RCHouseFilterService *ser = weakSelf.filterData.buldType[index];
                weakSelf.buldType = ser.dictCode;
            }else if (btnTag == 3) {
                RCHouseFilterStyle *sty = weakSelf.filterData.hxType[index];
                weakSelf.hxType = sty.dictCode;
            }else{
                RCHouseFilterArea *area = weakSelf.filterData.areaType[index];
                weakSelf.areaType = area.dictCode;
            }
        };
        return self.filterView;
    }
    RCHouseFilterView *fv = [RCHouseFilterView loadXibView];
    fv.hxn_width = HX_SCREEN_WIDTH;
    fv.hxn_height = 100.f;
    fv.target = self;
    fv.tableView = tableView;
    fv.filterData = self.filterData;
    self.filterView = fv;
    return fv;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCHouseDetailVC *dvc = [RCHouseDetailVC new];
    RCHouseList *house = self.houses[indexPath.row];
    dvc.uuid = house.uuid;
    dvc.lng = house.longitude;
    dvc.lat = house.dimension;
    [self.navigationController pushViewController:dvc animated:YES];
}
@end
