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

static NSString *const MyClientCell = @"MyClientCell";
static NSString *const MyBrokerCell = @"MyBrokerCell";
static NSString *const MyStoreCell = @"MyStoreCell";

@interface RCSearchClientVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RCSearchClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
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
}
#pragma mark -- 点击事件
-(void)cancelClickd
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataType == 1) {
        RCMyClientCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.target = self;
        return cell;
    }else if (self.dataType == 2){
        RCMyBrokerCell *cell = [tableView dequeueReusableCellWithIdentifier:MyBrokerCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        hx_weakify(self);
        cell.resetPwdCall = ^{
            RCChangePwdVC *pvc = [RCChangePwdVC new];
            [weakSelf.navigationController pushViewController:pvc animated:YES];
        };
        return cell;
    }else{
        RCMyStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:MyStoreCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        return 180.f;
    }else if (self.dataType == 2){
        return 140.f;
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
    label.text = @"   您搜索到2个客户";
    return label;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
