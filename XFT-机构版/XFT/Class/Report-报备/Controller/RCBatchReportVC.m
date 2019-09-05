//
//  RCBatchReportVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBatchReportVC.h"
#import "RCFilterCell.h"
#import "HXPlaceholderTextView.h"
#import "RCWishHouseVC.h"
#import "FSActionSheet.h"
#import "RCAddClientCell.h"
#import "WSDatePickerView.h"

static NSString *const FilterCell = @"FilterCell";
static NSString *const AddClientCell = @"AddClientCell";

@interface RCBatchReportVC ()<UITableViewDelegate,UITableViewDataSource,FSActionSheetDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *houseTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreClientViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *moreClientTableView;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UITextField *appointDate;
@property (weak, nonatomic) IBOutlet UITextField *appointTime;

/* 上一次选择的性别 */
@property(nonatomic,strong) UIButton *sexBtn;
/* 选择的楼盘 */
@property(nonatomic,strong) NSArray *houses;
/* 多加的客户 */
@property(nonatomic,strong) NSMutableArray *clients;

@end

@implementation RCBatchReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"批量报备"];
    self.remark.placeholder = @"请输入客户购房的补充说明(选填)";
    [self setUpTableView];
}
-(NSArray *)houses
{
    if (_houses == nil) {
        _houses = [NSArray array];
    }
    return _houses;
}
-(NSMutableArray *)clients
{
    if (_clients == nil) {
        _clients = [NSMutableArray array];
    }
    return _clients;
}
-(void)setUpTableView
{
    self.houseTableView.estimatedSectionHeaderHeight = 0;
    self.houseTableView.estimatedSectionFooterHeight = 0;
    self.houseTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.houseTableView.dataSource = self;
    self.houseTableView.delegate = self;
    self.houseTableView.showsVerticalScrollIndicator = NO;
    self.houseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.houseTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCFilterCell class]) bundle:nil] forCellReuseIdentifier:FilterCell];
    
    self.moreClientTableView.estimatedSectionHeaderHeight = 0;
    self.moreClientTableView.estimatedSectionFooterHeight = 0;
    self.moreClientTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.moreClientTableView.scrollEnabled = NO;
    self.moreClientTableView.dataSource = self;
    self.moreClientTableView.delegate = self;
    self.moreClientTableView.showsVerticalScrollIndicator = NO;
    self.moreClientTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.moreClientTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCAddClientCell class]) bundle:nil] forCellReuseIdentifier:AddClientCell];
}
#pragma mark -- 点击事件
- (IBAction)reportBtnClicked:(UIButton *)sender {
    hx_weakify(self);
    if (sender.tag == 0) {
        FSActionSheet *sheet = [[FSActionSheet alloc] initWithTitle:@"报备对象" delegate:self cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"融创西南展厅",@"融创西北展厅"]];
        [sheet showWithSelectedCompletion:^(NSInteger selectedIndex) {
            HXLog(@"报备对象-%zd",selectedIndex);
        }];
    }else if (sender.tag == 1) {
        RCWishHouseVC *hvc = [RCWishHouseVC new];
        [self.navigationController pushViewController:hvc animated:YES];
        self.houses = @[@"",@"",@""];
        self.houseViewHeight.constant = 50.f+44.f*self.houses.count;
        [self.houseTableView reloadData];
    }else if (sender.tag == 2) {
        [self.clients addObject:@""];
        self.moreClientViewHeight.constant = 160.f*self.clients.count;
        [self.moreClientTableView reloadData];
    }else if (sender.tag == 3) {
        //年-月-日
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
            
            NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            weakSelf.appointDate.text = dateString;
        }];
        datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
        datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
        datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
        [datepicker show];
    }else{
        //时-分
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowHourMinute CompleteBlock:^(NSDate *selectDate) {
            
            NSString *dateString = [selectDate stringWithFormat:@"HH:mm"];
            weakSelf.appointTime.text = dateString;
        }];
        datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
        datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
        datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
        [datepicker show];
    }
}
- (IBAction)clientSexClicked:(UIButton *)sender {
    self.sexBtn.selected = NO;
    self.sexBtn.boderColor = UIColorFromRGB(0xCCCCCC);
    sender.selected = YES;
    sender.boderColor = UIColorFromRGB(0x666666);
    self.sexBtn = sender;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == self.houseTableView)?self.houses.count:self.clients.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.houseTableView) {
        RCFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:FilterCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cate.text = @"选择的楼盘";
        return cell;
    }else{
        RCAddClientCell *cell = [tableView dequeueReusableCellWithIdentifier:AddClientCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        hx_weakify(self);
        cell.cutBtnCall = ^{
            hx_strongify(weakSelf);
            [strongSelf.clients removeLastObject];
            strongSelf.moreClientViewHeight.constant = 160.f*strongSelf.clients.count;
            [tableView reloadData];
        };
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return (tableView == self.houseTableView)?44.f:160.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
