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
#import "RCChangePwdVC.h"

static NSString *const MyBrokerCell = @"MyBrokerCell";

@interface RCMyBrokerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RCMyBrokerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"我的经纪人"];
    
    SPButton *filterItem = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    filterItem.hxn_size = CGSizeMake(44, 44);
    filterItem.imageTitleSpace = 5.f;
    filterItem.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [filterItem setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [filterItem setImage:HXGetImage(@"搜索") forState:UIControlStateNormal];
    [filterItem addTarget:self action:@selector(addBrokerClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:filterItem];
    
    SPButton *searchItem = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    searchItem.hxn_size = CGSizeMake(44, 44);
    [searchItem setImage:HXGetImage(@"搜索") forState:UIControlStateNormal];
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
}
#pragma mark -- 点击事件
-(void)addBrokerClicked
{
    RCAddBrokerVC *bvc = [RCAddBrokerVC new];
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
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCMyBrokerCell *cell = [tableView dequeueReusableCellWithIdentifier:MyBrokerCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    hx_weakify(self);
    cell.resetPwdCall = ^{
        RCChangePwdVC *pvc = [RCChangePwdVC new];
        [weakSelf.navigationController pushViewController:pvc animated:YES];
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
    label.text = @"共6个经纪人";
    [bgView addSubview:label];
    
    return bgView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    hx_weakify(self);
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定删除该经纪人吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
    }];
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确定" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"13496755975"]]];
    }];
    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [okButton setTitleColor:UIColorFromRGB(0xEC142D) forState:UIControlStateNormal];
    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
    self.zh_popupController = [[zhPopupController alloc] init];
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
}



@end
