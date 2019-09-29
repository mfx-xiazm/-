//
//  RCMyClientVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyClientVC.h"
#import "RCMyClientCell.h"
#import "RCMyClientStateCell.h"
#import "RCSearchClientVC.h"
#import "RCClientDetailVC.h"
#import "RCClientCodeView.h"
#import <zhPopupController.h>
#import <IQKeyboardManager.h>
#import "RCClientFilterView.h"
#import "YCMenuView.h"
#import "RCMyClientState.h"
#import "RCMyClient.h"
#import "zhAlertView.h"
#import "RCGoHouseVC.h"

static NSString *const MyClientCell = @"MyClientCell";
static NSString *const MyClientStateCell = @"MyClientStateCell";

@interface RCMyClientVC ()<UITableViewDelegate,UITableViewDataSource,RCClientFilterViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UIView *filterToolView;
@property (weak, nonatomic) IBOutlet SPButton *firstFilterBtn;
@property (weak, nonatomic) IBOutlet SPButton *secondFilterBtn;
/* 选中的那个排序按钮 */
@property(nonatomic,strong) SPButton *selectFilterBtn;
/* 是否向上排序 0向下排序 1向上排序*/
@property(nonatomic,copy) NSString *sankType;
/* 筛选状态值 */
@property(nonatomic,copy) NSString *sankValue;
/* 项目的uuid */
@property(nonatomic,copy) NSString *proUuid;
/* 左边客户状态 */
@property(nonatomic,strong) NSArray *clientStates;
/* 右边客户列表 */
@property(nonatomic,strong) NSMutableArray *clients;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 用户状态 1到访 2认筹 3认购 4签约 5退房 6失效 7报备 */
@property(nonatomic,assign) NSInteger cusType;
/* 选中的左边的索引 */
@property(nonatomic,assign) NSInteger clientIndex;
/* 报备时间开始 */
@property(nonatomic,assign) NSInteger reportStart;
/* 报备时间结束 */
@property(nonatomic,assign) NSInteger reportEnd;
/* 首次到访时间开始 */
@property(nonatomic,assign) NSInteger firstVisitStart;
/* 首次到访时间结束 */
@property(nonatomic,assign) NSInteger firstVisitEnd;
@end

@implementation RCMyClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的客户"];
    self.cusType = 7;//初始化已报备
    self.clientIndex = 0;//初始化选中左边第一行
    self.reportStart = 0;//初始化筛选时间
    self.reportEnd = 0;
    self.firstVisitStart = 0;
    self.firstVisitEnd = 0;
    self.filterToolView.hidden = YES;
    [self setUpTableView];
    [self setUpNavBar];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
-(void)setProUuid:(NSString *)proUuid
{
    if (![_proUuid isEqualToString:proUuid]) {// 如果选择不同就重新加载项目
        _proUuid = proUuid;
        [self getClientStateRuquest];
    }
}
- (NSMutableArray *)clients
{
    if (_clients == nil) {
        _clients = [NSMutableArray array];
    }
    return _clients;
}
#pragma mark -- 视图UI
-(void)setUpNavBar
{
    SPButton *menu = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
    menu.hxn_size = CGSizeMake(150 , 44);
    menu.imageTitleSpace = 5.f;
    menu.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [menu setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    if ([MSUserManager sharedInstance].curUserInfo.dropValueDTOS.count) {
        MSDropValues *drop = [MSUserManager sharedInstance].curUserInfo.dropValueDTOS.firstObject;
        [menu setTitle:drop.label forState:UIControlStateNormal];
        self.proUuid = drop.value;
    }else{
        [menu setTitle:@"默认项目" forState:UIControlStateNormal];
        self.proUuid = @"";
    }
    [menu setImage:HXGetImage(@"Shape") forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = menu;
    
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    
    SPButton *searchItem = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    searchItem.hxn_size = CGSizeMake(44, 44);
    [searchItem setImage:HXGetImage(@"icon_search") forState:UIControlStateNormal];
    [searchItem addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:searchItem];
    
    self.navigationItem.rightBarButtonItem = item2;
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.rightTableView.estimatedRowHeight = 100;//预估高度
    self.rightTableView.rowHeight = UITableViewAutomaticDimension;
    self.rightTableView.estimatedSectionHeaderHeight = 0;
    self.rightTableView.estimatedSectionFooterHeight = 0;
    
    self.rightTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
    
    self.rightTableView.showsVerticalScrollIndicator = NO;
    
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyClientCell class]) bundle:nil] forCellReuseIdentifier:MyClientCell];
    self.rightTableView.hidden = YES;
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.leftTableView.estimatedRowHeight = 100;//预估高度
    self.leftTableView.rowHeight = UITableViewAutomaticDimension;
    self.leftTableView.estimatedSectionHeaderHeight = 0;
    self.leftTableView.estimatedSectionFooterHeight = 0;
    
    self.leftTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    
    self.leftTableView.showsVerticalScrollIndicator = NO;
    
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyClientStateCell class]) bundle:nil] forCellReuseIdentifier:MyClientStateCell];
    self.rightTableView.hidden = YES;

}

/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.rightTableView.mj_header.automaticallyChangeAlpha = YES;
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.rightTableView.mj_footer resetNoMoreData];
        [strongSelf getClientDataRequest:YES completeCall:^{
            [strongSelf.rightTableView reloadData];
        }];
    }];
    //追加尾部刷新
    self.rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getClientDataRequest:NO completeCall:^{
            [strongSelf.rightTableView reloadData];
        }];
    }];
}
#pragma mark -- 接口请求
-(void)getClientStateRuquest
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
        /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
        NSString *actionPath = nil;
        if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1 || [MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
            data[@"agentUuid"] = @"";//中介门店uuid
            data[@"firstVisitEnd"] = @(self.firstVisitEnd);
            data[@"firstVisitStart"] = @(self.firstVisitStart);
            data[@"middlemanUuid"] = @"";//中介经济人uuid
            data[@"proUuid"] = self.proUuid;//项目uuid
            data[@"reportEnd"] = @(self.reportEnd);
            data[@"reportStart"] = @(self.reportStart);
            data[@"reportUuid"] = @"";//项目统一报备人uuid
            actionPath = @"cus/cus/mechanism/getCusGgCount";
        }else{
            data[@"reportStart"] = @(self.reportStart);
            data[@"reportEnd"] = @(self.reportEnd);
            data[@"firstVisitStart"] = @(self.firstVisitStart);
            data[@"firstVisitEnd"] = @(self.firstVisitEnd);
            actionPath = @"cus/cus/mechanism/getCusMdCount";
        }
        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:actionPath parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSArray *names = @[@"已报备",@"已到访",@"已认筹",@"已认购",@"已签约",@"已退房",@"已失效"];
                NSArray *nums = @[responseObject[@"data"][@"hasReport"],responseObject[@"data"][@"hasVisited"],responseObject[@"data"][@"hasRecognition"],responseObject[@"data"][@"hasBuy"],responseObject[@"data"][@"hasSign"],responseObject[@"data"][@"hasCheckOut"],responseObject[@"data"][@"hasInvalid"]];
                NSArray *states = @[@"7",@"1",@"2",@"3",@"4",@"5",@"6"];
                NSMutableArray *tempArr = [NSMutableArray array];
                for (int i=0; i<7; i++) {
                    RCMyClientState *cs = [[RCMyClientState alloc] init];
                    cs.name = names[i];
                    cs.num = [NSString stringWithFormat:@"%@",nums[i]];
                    cs.cusType = [states[i] integerValue];
                    [tempArr addObject:cs];
                }
                strongSelf.clientStates = tempArr;
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
        [strongSelf getClientDataRequest:YES completeCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        // 执行顺序10
        hx_strongify(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.filterToolView.hidden = NO;
            strongSelf.leftTableView.hidden = NO;
            strongSelf.rightTableView.hidden = NO;
            [strongSelf.leftTableView reloadData];
            [strongSelf.rightTableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:strongSelf.clientIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            });
        });
    });
}
-(void)getClientDataRequest:(BOOL)isRefresh completeCall:(void(^)(void))completeCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    NSString *actionPath = nil;
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1 || [MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        data[@"agentUuid"] = @"";//中介门店uuid
        data[@"cusType"] = @(self.cusType);//用户状态1到访 2认筹 3认购 4签约 5退房 6失效 7报备
        data[@"firstVisitStart"] = @(self.firstVisitStart);//首次到访时间开始
        data[@"firstVisitEnd"] = @(self.firstVisitEnd);//首次到访时间结束
        data[@"middlemanUuid"] = @"";//中介经济人uuid
        data[@"proUuid"] = self.proUuid;//项目uuid
        data[@"reportStart"] = @(self.reportStart);//报备时间开始
        data[@"reportEnd"] = @(self.reportEnd);//报备时间结束
        data[@"reportUuid"] = @"";//项目统一报备人uuid
        
        actionPath = @"cus/cus/mechanism/getCusGgTypeInfo";
    }else{
        data[@"cusType"] = @(self.cusType);//用户状态1到访 2认筹 3认购 4签约 5退房 6失效 7报备
        data[@"firstVisitEnd"] = @(self.firstVisitEnd);//首次到访时间结束
        data[@"firstVisitStart"] = @(self.firstVisitStart);//首次到访时间开始
        data[@"reportEnd"] = @(self.reportEnd);//报备时间结束
        data[@"reportStart"] = @(self.reportStart);//报备时间开始
       
        actionPath = @"cus/cus/mechanism/getCusMdTypeInfo";
    }

    NSMutableDictionary *page = [NSMutableDictionary dictionary];
    if (isRefresh) {
        page[@"current"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        page[@"current"] = @(pagenum);//第几页
    }
    page[@"size"] = @"10";
    if (self.selectFilterBtn) {
        if (self.sankType) {
            if ([self.sankType isEqualToString:@"1"]) {//
                page[@"ascs"] = @[self.sankValue];//升序
            }else{
                page[@"descs"] = @[self.sankValue];//降序
            }
        }
    }
    parameters[@"data"] = data;
    parameters[@"page"] = page;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:actionPath parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.rightTableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.clients removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyClient class] json:responseObject[@"data"][@"records"]];
                [strongSelf.clients addObjectsFromArray:arrt];
            }else{
                [strongSelf.rightTableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyClient class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.clients addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.rightTableView.mj_footer endRefreshingWithNoMoreData];
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
#pragma mark -- 点击事件
-(void)menuClicked:(SPButton *)menuBtn
{
    if (![MSUserManager sharedInstance].curUserInfo.dropValueDTOS.count) {
        return;
    }
    
    NSMutableArray *tempArr = [NSMutableArray array];
    hx_weakify(self);
    for (MSDropValues *drop in [MSUserManager sharedInstance].curUserInfo.dropValueDTOS) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:drop.label image:nil handler:^(YCMenuAction *action) {
            [menuBtn setTitle:action.title forState:UIControlStateNormal];
            weakSelf.proUuid = action.content;
            [menuBtn layoutSubviews];
        }];
        action.content = drop.value;
        [tempArr addObject:action];
    }
    
    YCMenuView *view = [YCMenuView menuWithActions:tempArr width:140 atPoint:CGPointMake(HX_SCREEN_WIDTH/2.0, self.HXNavBarHeight)];
    view.currentText = menuBtn.currentTitle;
    view.currentTextColor = HXControlBg;
    view.isShowShadow = NO;
    // 显示
    [view show];
}
- (IBAction)firstFilterBtn:(SPButton *)sender {
    if (self.selectFilterBtn != sender) {//如果前面选中的不是这个排序，就重置排序条件
        self.sankType = nil;
    }
    self.selectFilterBtn = sender;// 记录选中的按钮
    // 重置第二个排序
    [self.secondFilterBtn setImage:HXGetImage(@"icon_qiehuan_moren") forState:UIControlStateNormal];
    /* 是否向上排序 0向下排序 1向上排序*/
    if ([self.sankType isEqualToString:@"0"]) {//降序
        self.sankType = @"1";
        [self.firstFilterBtn setImage:HXGetImage(@"icon_qiehuan_up") forState:UIControlStateNormal];
    }else{//升序
        self.sankType = @"0";
        [self.firstFilterBtn setImage:HXGetImage(@"icon_qiehuan_down") forState:UIControlStateNormal];
    }
    /* 用户状态 1到访 2认筹 3认购 4签约 5退房 6失效 7报备 */
    if (self.cusType == 1) {
        self.sankValue = @"lastVistTime";
    }else if (self.cusType == 2) {
        self.sankValue = @"recognitionTime";
    }else if (self.cusType == 3) {
        self.sankValue = @"buyTime";
    }else if (self.cusType == 4) {
        self.sankValue = @"signTime";
    }else if (self.cusType == 5) {
        self.sankValue = @"checkOutTime";
    }else if (self.cusType == 6) {
        self.sankValue = @"invalidTime";
    }else{
        self.sankValue = @"lastRemarkTime";
    }
    hx_weakify(self);
    [self getClientDataRequest:YES completeCall:^{
        hx_strongify(weakSelf);
        [strongSelf.rightTableView reloadData];
    }];
}
- (IBAction)secondFilterBtn:(SPButton *)sender {
    if (self.selectFilterBtn != sender) {//如果前面选中的不是这个排序，就重置排序条件
        self.sankType = nil;
    }
    
    self.selectFilterBtn = sender;// 记录选中的按钮
    // 重置第一个排序
    [self.firstFilterBtn setImage:HXGetImage(@"icon_qiehuan_moren") forState:UIControlStateNormal];
    /* 是否向上排序 0向下排序 1向上排序*/
    if ([self.sankType isEqualToString:@"0"]) {//降序
        self.sankType = @"1";
        [self.secondFilterBtn setImage:HXGetImage(@"icon_qiehuan_up") forState:UIControlStateNormal];
    }else{//升序
        self.sankType = @"0";
        [self.secondFilterBtn setImage:HXGetImage(@"icon_qiehuan_down") forState:UIControlStateNormal];
    }
    self.sankValue = @"seeTime";
    hx_weakify(self);
    [self getClientDataRequest:YES completeCall:^{
        hx_strongify(weakSelf);
        [strongSelf.rightTableView reloadData];
    }];
}
-(IBAction)filterClicked:(UIButton *)sender
{
    RCClientFilterView *filter = [RCClientFilterView loadXibView];
    filter.delegate = self;
    filter.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-80, self.view.hxn_height);
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeRight;
    self.zh_popupController.maskAlpha = 0.15;
    [self.zh_popupController presentContentView:filter duration:0.25 springAnimated:NO inView:self.contentView];
}
-(void)searchClicked
{
    RCSearchClientVC *cvc = [RCSearchClientVC new];
    cvc.dataType = 1;
    cvc.proUuid = self.proUuid;
    [self.navigationController pushViewController:cvc animated:YES];
}
#pragma mark -- RCClientFilterViewDelegate
-(void)filterDidConfirm:(RCClientFilterView *)filter reportBeginTime:(NSString *)reportBegin reportEndTime:(NSString *)reportEnd visitBeginTime:(NSString *)visitBegin visitEndTime:(NSString *)visitEnd
{
    [self.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    if (reportBegin && reportBegin.length) {
        NSDate *date = [formatter dateFromString:reportBegin];
        self.reportStart = [date timeIntervalSince1970];
    }else{
        self.reportStart = 0;
    }
    
    if (reportEnd && reportEnd.length) {
        NSDate *date = [formatter dateFromString:reportEnd];
        self.reportEnd = [date timeIntervalSince1970];
    }else{
        self.reportEnd = 0;
    }
    
    if (visitBegin && visitBegin.length) {
        NSDate *date = [formatter dateFromString:visitBegin];
        self.firstVisitStart = [date timeIntervalSince1970];
    }else{
        self.firstVisitStart = 0;
    }
    
    if (visitEnd && visitEnd.length) {
        NSDate *date = [formatter dateFromString:visitEnd];
        self.firstVisitEnd = [date timeIntervalSince1970];
    }else{
        self.firstVisitEnd = 0;
    }
    
    [self getClientStateRuquest];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return self.clientStates.count;
    }else{
        return self.clients.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        RCMyClientStateCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientStateCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCMyClientState *clientState = self.clientStates[indexPath.row];
        cell.clientState1 = clientState;
        return cell;
    }else{
        RCMyClientCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cusType = self.cusType;
        RCMyClient *client = self.clients[indexPath.row];
        /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
        if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1 || [MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
            cell.remarkView.hidden = YES;
            cell.brokerView.hidden = YES;
            cell.mangeView.hidden = NO;
            cell.client = client;
        }else{
            cell.remarkView.hidden = NO;
            cell.brokerView.hidden = NO;
            cell.mangeView.hidden = YES;
            cell.client1 = client;
        }
        hx_weakify(self);
        cell.clientHandleCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 1) {
                //    if (隐号报备) {
                RCClientCodeView *codeView = [RCClientCodeView loadXibView];
                codeView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 265.f);
                codeView.closeBtnCall = ^{
                    [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
                };
                strongSelf.zh_popupController = [[zhPopupController alloc] init];
                strongSelf.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
                [strongSelf.zh_popupController presentContentView:codeView duration:0.25 springAnimated:NO];
                //    }else{
                //        RCGoHouseVC *hvc = [RCGoHouseVC new];
                //        hvc.cusUuid = _client1.cusUuid;
                //        [self.target.navigationController pushViewController:hvc animated:YES];
                //    }
            }else if (index == 2) {
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:client.phone constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                }];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"拨打" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",client.phone]]];
                }];
                cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                strongSelf.zh_popupController = [[zhPopupController alloc] init];
                [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }else if (index == 3) {
                NSString *phoneStr = [NSString stringWithFormat:@"%@",client.phone];//发短信的号码
                NSString *urlStr = [NSString stringWithFormat:@"sms://%@", phoneStr];
                NSURL *url = [NSURL URLWithString:urlStr];
                [[UIApplication sharedApplication] openURL:url];
            }else{
                RCClientDetailVC *dvc = [RCClientDetailVC  new];
                dvc.cusUuid = client.cusUuid;
                [strongSelf.navigationController pushViewController:dvc animated:YES];
            }
        };
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (tableView == self.leftTableView) {
        return 75.f;
    }else{
        /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
        if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1 || [MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
            return 160.f;
        }else{
            return 160.f+60.f;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        self.sankType = nil;
        self.sankValue = nil;
        self.selectFilterBtn = nil;
        [self.firstFilterBtn setImage:HXGetImage(@"icon_qiehuan_moren") forState:UIControlStateNormal];
        [self.secondFilterBtn setImage:HXGetImage(@"icon_qiehuan_moren") forState:UIControlStateNormal];
        self.clientIndex = indexPath.row;
        RCMyClientState *clientState = self.clientStates[indexPath.row];
        self.cusType = clientState.cusType;
        hx_weakify(self);
        [self getClientDataRequest:YES completeCall:^{
            [weakSelf.rightTableView reloadData];
        }];
        switch (indexPath.row) {
            case 0:{
                [self.firstFilterBtn setTitle:@"最后备注" forState:UIControlStateNormal];
            }
                break;
            case 1:{
                [self.firstFilterBtn setTitle:@"最近到访" forState:UIControlStateNormal];
            }
                break;
            case 2:{
                [self.firstFilterBtn setTitle:@"认筹时间" forState:UIControlStateNormal];
            }
                break;
            case 3:{
                [self.firstFilterBtn setTitle:@"认购时间" forState:UIControlStateNormal];
            }
                break;
            case 4:{
                [self.firstFilterBtn setTitle:@"签约时间" forState:UIControlStateNormal];
            }
                break;
            case 5:{
                [self.firstFilterBtn setTitle:@"退房时间" forState:UIControlStateNormal];
            }
                break;
            case 6:{
                [self.firstFilterBtn setTitle:@"失效时间" forState:UIControlStateNormal];
            }
                break;
        }
    }else{
        RCClientDetailVC *dvc = [RCClientDetailVC  new];
        RCMyClient *client = self.clients[indexPath.row];
        dvc.cusUuid = client.cusUuid;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}


@end
