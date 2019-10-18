//
//  RCMyStoreVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyStoreVC.h"
#import "RCMyStoreCell.h"
#import "RCSearchClientVC.h"
#import "RCTimeFilterView.h"
#import "RCAddStoreVC.h"
#import "RCChangePwdVC.h"
#import "WSDatePickerView.h"
#import "RCMyStore.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

static NSString *const MyStoreCell = @"MyStoreCell";
@interface RCMyStoreVC ()<UITableViewDelegate,UITableViewDataSource,RCTimeFilterViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 门店列表 */
@property(nonatomic,strong) NSMutableArray *stores;
/* 门店总数 */
@property(nonatomic,copy) NSString *total;
@end

@implementation RCMyStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    [self getStoreListDataRequest:YES];
}
-(NSMutableArray *)stores
{
    if (_stores == nil) {
        _stores = [NSMutableArray array];
    }
    return _stores;
}
#pragma mark - 视图UI
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"我的门店"];
    
    SPButton *filterItem = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    filterItem.hxn_size = CGSizeMake(44, 44);
    filterItem.imageTitleSpace = 5.f;
    filterItem.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [filterItem setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [filterItem setImage:HXGetImage(@"icon__top_add") forState:UIControlStateNormal];
    [filterItem addTarget:self action:@selector(addStoreClicked) forControlEvents:UIControlEventTouchUpInside];
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
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
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
        [strongSelf getStoreListDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getStoreListDataRequest:NO];
    }];
}
#pragma mark -- 接口请求
/** 门店筛选列表 */
-(void)getStoreListDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"keywords"] = @"";
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
                [strongSelf.stores removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyStore class] json:responseObject[@"data"][@"shopList"][@"records"]];
                [strongSelf.stores addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"shopList"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"shopList"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyStore class] json:responseObject[@"data"][@"shopList"][@"records"]];
                    [strongSelf.stores addObjectsFromArray:arrt];
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
-(void)addStoreClicked
{
    RCAddStoreVC *svc = [RCAddStoreVC new];
    hx_weakify(self);
    svc.addStoreCall = ^{
        [weakSelf getStoreListDataRequest:YES];
    };
    [self.navigationController pushViewController:svc animated:YES];
}
-(void)searchClicked
{
    RCSearchClientVC *cvc = [RCSearchClientVC new];
    cvc.dataType = 3;
    [self.navigationController pushViewController:cvc animated:YES];
}
-(void)filterBtnClicked
{
    RCTimeFilterView *filter = [RCTimeFilterView loadXibView];
    filter.delegate = self;
    [filter filterShowInSuperView:self.view];
}
#pragma mark -- RCTimeFilterViewDelegate
//出现位置
- (CGPoint)filter_positionInSuperView
{
    return CGPointMake(0.f, 0.f);
}
- (void)filter:(RCTimeFilterView *)filter  didSelectTextField:(UITextField *)textField
{
    //年-月-日
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        textField.text = dateString;
    }];
    datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
    [datepicker show];
}
- (void)filter:(RCTimeFilterView *)filter begin:(NSString *)beginTime end:(NSString *)endTime
{
    [filter filterHidden];
    HXLog(@"开始时间-结束时间");
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stores.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCMyStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:MyStoreCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCMyStore *store = self.stores[indexPath.row];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [UIView new];
    bgView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44);
    bgView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 0, HX_SCREEN_WIDTH/2.0, 44);
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = [NSString stringWithFormat:@"共%@个门店",self.total];
    [bgView addSubview:label];
    
    /*
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(HX_SCREEN_WIDTH/2.0, 0, HX_SCREEN_WIDTH/2.0-15, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setImage:HXGetImage(@"icon_shaixuan_click") forState:UIControlStateNormal];
    [btn setTitle:@"筛选" forState:UIControlStateNormal];
    [btn setTitleColor:HXControlBg forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
    [btn addTarget:self action:@selector(filterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    */
    
    return bgView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
