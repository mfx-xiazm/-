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

static NSString *const MyClientCell = @"MyClientCell";
static NSString *const MyClientStateCell = @"MyClientStateCell";

@interface RCMyClientVC ()<UITableViewDelegate,UITableViewDataSource,RCClientFilterViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@end

@implementation RCMyClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的客户"];
    [self setUpNavBar];
    [self setUpTableView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    });
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
-(void)setUpNavBar
{
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
}
#pragma mark -- 点击事件
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
    [self.navigationController pushViewController:cvc animated:YES];
}
#pragma mark -- RCClientFilterViewDelegate
-(void)filterDidConfirm:(RCClientFilterView *)filter beginTime:(NSString *)begin endTime:(NSString *)end
{
    HXLog(@"开始时间-%@结束时间-%@",begin,end);
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        RCMyClientStateCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientStateCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
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
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (tableView == self.leftTableView) {
        return 75.f;
    }else{
        if (indexPath.row %2) {
            return 160.f+60.f;
        }else{
            return 160.f;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.rightTableView) {
        RCClientDetailVC *dvc = [RCClientDetailVC  new];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}


@end
