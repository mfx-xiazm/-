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
#import "RCMyClientFilter.h"
#import "RCReportHouse.h"

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
/* 左边客户状态 */
@property(nonatomic,strong) NSArray *clientStates;
/* 右边客户列表 */
@property(nonatomic,strong) NSMutableArray *clients;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 用户状态 0:已报备 2:已到访 4:已认筹 5:已认购 6:已签约 7:已退房 100:已失效 (默认状态为:0) */
@property(nonatomic,assign) NSInteger cusType;
/* 选中的左边的索引 */
@property(nonatomic,assign) NSInteger clientIndex;
/* 筛选条件 */
@property(nonatomic,strong) RCMyClientFilter *filterModel;
/* 所有项目列表 */
@property(nonatomic,strong) NSArray *proList;
/* 项目的uuid */
@property(nonatomic,copy) NSString *proUuid;
/* 项目的名字 */
@property(nonatomic,copy) NSString *proName;
@end

@implementation RCMyClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的客户"];
    self.cusType = 0;//初始化已报备
    self.clientIndex = 0;//初始化选中左边第一行
    self.filterToolView.hidden = YES;
    [self setUpTableView];
    [self setUpRefresh];
    [self queryProListRequest];
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
        [self getClientDataRequest:YES];
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
    if (self.proList.count) {
        RCReportHouse *drop = self.proList.firstObject;
        [menu setTitle:drop.proName forState:UIControlStateNormal];
        self.proName = drop.proName;
        self.proUuid = drop.uuid;
    }else{
        [menu setTitle:@"默认项目" forState:UIControlStateNormal];
        self.proName = @"";
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
        [strongSelf getClientDataRequest:YES];
    }];
    //追加尾部刷新
    self.rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getClientDataRequest:NO];
    }];
}
#pragma mark -- 接口请求
/** 获取项目列表 */
-(void)queryProListRequest
{
    hx_weakify(self);
    
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/organization/queryProList" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.proList = [NSArray yy_modelArrayWithClass:[RCReportHouse class] json:responseObject[@"data"][@"page"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf setUpNavBar];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 获取客户数据 */
-(void)getClientDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    data[@"projectId"] = self.proUuid;//项目ID
    data[@"cusState"] = @(self.cusType);//客户状态 0:已报备 2:已到访 4:已认筹 5:已认购 6:已签约 7:已退房 100:已失效 (默认状态为:0)
    if (self.selectFilterBtn) {
        if (self.selectFilterBtn.tag == 1) {//其他类型排序
            if ([self.sankType isEqualToString:@"1"]) {
                data[@"stateAsc"] = @"asc";//状态升序
            }else{
                data[@"stateDesc"] = @"desc";//状态降序
            }
        }else{//报备时间排序
            if ([self.sankType isEqualToString:@"1"]) {
                data[@"baobeiAsc"] = @"asc";//状态升序
            }else{
                data[@"baobeiDesc"] = @"desc";//状态降序
            }
        }
    }
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1) {
        // 门店  项目报备人
        data[@"store"] = (self.filterModel.selectStore && self.filterModel.selectStore.uuid)?self.filterModel.selectStore.uuid:@"all";//中介门店 全部 :all(小写),其他:uuid
        data[@"report"] = (self.filterModel.selectReporter && self.filterModel.selectReporter.uuid)?self.filterModel.selectReporter.uuid:@"all";//项目统一报备人 全部:all(小写),其他:uuid
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {
        // 只有时间
        
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        // 中介经纪人
        data[@"agent"] = (self.filterModel.selectBroker && self.filterModel.selectBroker.uuid)?self.filterModel.selectBroker.uuid:@"all";//中介经纪人 全部:all(小写),其他:uuid
    }else{
        // 只有时间
        
    }
    data[@"firstVisitEndTime"] = (self.filterModel.firstVisitEnd == 0)?@"":@(self.filterModel.firstVisitEnd);//首次到访结束时间(10位时间戳)
    data[@"firstVisitStateTime"] = (self.filterModel.firstVisitStart == 0)?@"":@(self.filterModel.firstVisitStart);//首次到访开始时间(10位时间戳)
    data[@"reportEndTime"] = (self.filterModel.reportEnd == 0)?@"":@(self.filterModel.reportEnd);//报备结束时间(10位时间戳)
    data[@"reportStartTime"] = (self.filterModel.reportStart == 0)?@"":@(self.filterModel.reportStart);//报备开始时间(10位时间戳)
    
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
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/organization/myClient" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.rightTableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                
                NSArray *names = @[@"已报备",@"已到访",@"已认筹",@"已认购",@"已签约",@"已退房",@"已失效"];
                NSArray *nums = @[responseObject[@"data"][@"reportedNum"],responseObject[@"data"][@"haveVisitedNum"],responseObject[@"data"][@"recognizedNum"],responseObject[@"data"][@"subscribedNum"],responseObject[@"data"][@"signedNum"],responseObject[@"data"][@"checkOutNum"],responseObject[@"data"][@"expiredNum"]];
               
                //0:已报备 2:已到访 4:已认筹 5:已认购 6:已签约 7:已退房 100:已失效
                NSArray *states = @[@"0",@"2",@"4",@"5",@"6",@"7",@"100"];
                NSMutableArray *tempArr = [NSMutableArray array];
                for (int i=0; i<7; i++) {
                    RCMyClientState *cs = [[RCMyClientState alloc] init];
                    cs.name = names[i];
                    cs.num = [NSString stringWithFormat:@"%@",nums[i]];
                    cs.cusType = [states[i] integerValue];
                    [tempArr addObject:cs];
                }
                strongSelf.clientStates = tempArr;
                
                [strongSelf.clients removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyClient class] json:responseObject[@"data"][@"page"]];
                [strongSelf.clients addObjectsFromArray:arrt];
            }else{
                [strongSelf.rightTableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"page"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"page"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyClient class] json:responseObject[@"data"][@"page"]];
                    [strongSelf.clients addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.rightTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
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
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 获取筛选数据 */
-(void)getClientFilterDataRequest:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    parameters[@"data"] = @{};
    
    hx_weakify(self);
    
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/organization/myClientFilter" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.filterModel = [RCMyClientFilter yy_modelWithDictionary:responseObject[@"data"]];
            if (completedCall) {
                completedCall();
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
    
}
#pragma mark -- 点击事件
-(void)menuClicked:(SPButton *)menuBtn
{
    if (!self.proList.count) {
        return;
    }
    
    NSMutableArray *tempArr = [NSMutableArray array];
    hx_weakify(self);
    for (RCReportHouse *drop in self.proList) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:drop.proName image:nil handler:^(YCMenuAction *action) {
            [menuBtn setTitle:action.title forState:UIControlStateNormal];
            weakSelf.proName = action.title;
            weakSelf.proUuid = action.content;
            [menuBtn layoutSubviews];
        }];
        action.content = drop.uuid;
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

    [self getClientDataRequest:YES];
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
    [self getClientDataRequest:YES];
}
-(IBAction)filterClicked:(UIButton *)sender
{
    if (!self.filterModel) {
        hx_weakify(self);
        [self getClientFilterDataRequest:^{
            hx_strongify(weakSelf);
            [strongSelf showClientFilterView];
        }];
    }else{
        [self showClientFilterView];
    }
}
-(void)showClientFilterView
{
    RCClientFilterView *filter = [RCClientFilterView loadXibView];
    filter.delegate = self;
    filter.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-80, self.view.hxn_height);
    filter.cusType = self.cusType;
    filter.filterModel = self.filterModel;
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
-(void)filterDidConfirm:(RCClientFilterView *)filter
{
    [self.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
  
    [self getClientDataRequest:YES];
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
            cell.proName = self.proName;
            cell.remarkView.hidden = YES;
            cell.brokerView.hidden = YES;
            cell.mangeView.hidden = NO;
        }else{
            cell.remarkView.hidden = NO;
            cell.brokerView.hidden = NO;
            cell.mangeView.hidden = YES;
        }
        cell.client = client;
        hx_weakify(self);
        cell.clientHandleCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 1) {
                if (client.isHidden) {
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
                    hvc.cusUuid = client.uuid;
                    [strongSelf.navigationController pushViewController:hvc animated:YES];
                }
            }else if (index == 2) {
                if (client.isHidden) {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"隐号"];
                }else{
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
                }
                
            }else if (index == 3) {
                if (client.isHidden) {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"隐号"];
                }else{
                    NSString *phoneStr = [NSString stringWithFormat:@"%@",client.phone];//发短信的号码
                    NSString *urlStr = [NSString stringWithFormat:@"sms://%@", phoneStr];
                    NSURL *url = [NSURL URLWithString:urlStr];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }else{
                RCClientDetailVC *dvc = [RCClientDetailVC  new];
                dvc.cusUuid = client.uuid;
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
        self.clientIndex = indexPath.row;
        RCMyClientState *clientState = self.clientStates[indexPath.row];
        self.cusType = clientState.cusType;
        [self getClientDataRequest:YES];
        
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
        dvc.cusUuid = client.uuid;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}


@end
