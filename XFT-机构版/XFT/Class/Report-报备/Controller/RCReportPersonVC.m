//
//  RCReportPersonVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCReportPersonVC.h"
#import "RCReportPersonCell.h"
#import "HXSearchBar.h"
#import "RCReporter.h"

static NSString *const ReportPersonCell = @"ReportPersonCell";

@interface RCReportPersonVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 报备人列表 */
@property(nonatomic,strong) NSMutableArray *reporters;
/* 关键词 */
@property(nonatomic,strong) NSString *keywords;
@end

@implementation RCReportPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self queryOrgShopListRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)setKeywords:(NSString *)keywords
{
    if (![_keywords isEqualToString:keywords]) {
        _keywords = keywords;
        [self queryOrgShopListRequest];
    }
}
-(NSMutableArray *)reporters
{
    if (_reporters == nil) {
        // HXLog(@"这里应该加入自己,如过没有选中的报备人就默认先选中自己");
        _reporters = [NSMutableArray array];
        RCReporter *report = [RCReporter new];
        report.orgname = [MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName;
        report.orguuid = [MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgUuid;
        report.shopname = [MSUserManager sharedInstance].curUserInfo.orgUserInfo.shopName;
        report.shopuuid = [MSUserManager sharedInstance].curUserInfo.orgUserInfo.shopUuid;
        report.accMuuid = [MSUserManager sharedInstance].curUserInfo.agentLoginInside.uuid;
        report.accMname = [MSUserManager sharedInstance].curUserInfo.agentLoginInside.name;
        if (!self.selectReporter) {
            report.isSelected = YES;
        }
        [_reporters addObject:report];
    }
    return _reporters;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    HXSearchBar *search = [HXSearchBar searchBar];
    search.backgroundColor = UIColorFromRGB(0xf5f5f5);
    search.hxn_width = HX_SCREEN_WIDTH - 80;
    search.hxn_height = 32;
    search.layer.cornerRadius = 32/2.f;
    search.layer.masksToBounds = YES;
    search.delegate = self;
    self.navigationItem.titleView = search;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCReportPersonCell class]) bundle:nil] forCellReuseIdentifier:ReportPersonCell];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField hasText]) {
        self.keywords = textField.text;
    }else{
        self.keywords = @"";
    }
    return YES;
}
#pragma mark -- 点击事件
- (IBAction)sureClicked:(UIButton *)sender {
    if (self.selectReporterCall) {
        self.selectReporterCall(self.selectReporter);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 接口请求
-(void)queryOrgShopListRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"keywords"] = (self.keywords && self.keywords.length)?self.keywords:@"";
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/orgbaobei/queryOrgShopList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            NSArray *arrtm = [NSArray yy_modelArrayWithClass:[RCReporter class] json:responseObject[@"data"]];
            [strongSelf.reporters addObjectsFromArray:arrtm];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleReporterData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleReporterData
{
    if (self.selectReporter) {
        for (RCReporter *reporter in self.reporters) {
            if ([reporter.shopuuid isEqualToString:self.selectReporter.shopuuid] && [reporter.orguuid isEqualToString:self.selectReporter.orguuid] && [reporter.accMuuid isEqualToString:self.selectReporter.accMuuid]) {
                reporter.isSelected = YES;
                self.selectReporter = reporter;
                break;
            }
        }
    }
    [self.tableView reloadData];
}
#pragma mark -- 点击事件
-(void)sureClickd
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reporters.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCReportPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:ReportPersonCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCReporter *reporter = self.reporters[indexPath.row];
    cell.reporter = reporter;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectReporter.isSelected = NO;

    RCReporter *reporter = self.reporters[indexPath.row];
    reporter.isSelected = YES;
    
    self.selectReporter = reporter;
    
    [tableView reloadData];
}
@end
