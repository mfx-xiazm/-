//
//  RCReportVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCReportVC.h"
#import "HXPlaceholderTextView.h"
#import "RCFilterCell.h"
#import "RCWishHouseVC.h"
#import "RCBatchReportVC.h"
#import "WSDatePickerView.h"
#import "RCReportPersonVC.h"
#import "RCReportResultVC.h"
#import "RCAddPhoneCell.h"

static NSString *const FilterCell = @"FilterCell";
static NSString *const AddPhoneCell = @"AddPhoneCell";

@interface RCReportVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *houseTableView;
@property (weak, nonatomic) IBOutlet UITableView *morePhoneView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *morePhoneViewHeight;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UITextField *appointDate;
@property (weak, nonatomic) IBOutlet UIView *reportPersonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reportPersonViewHeight;
/* 选择的楼盘 */
@property(nonatomic,strong) NSArray *houses;
/* 多加的电话 */
@property(nonatomic,strong) NSMutableArray *phones;
@end

@implementation RCReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"报备"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(batchReportClicked) title:@"批量报备" font:[UIFont systemFontOfSize:16] titleColor:UIColorFromRGB(0x333333) highlightedColor:UIColorFromRGB(0x333333) titleEdgeInsets:UIEdgeInsetsZero];
    self.remark.placeholder = @"请输入补充说明(选填)";
    [self setUpTableView];
}
-(NSArray *)houses
{
    if (_houses == nil) {
        _houses = [NSArray array];
    }
    return _houses;
}
-(NSMutableArray *)phones
{
    if (_phones == nil) {
        _phones = [NSMutableArray array];
    }
    return _phones;
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
    
    self.morePhoneView.estimatedSectionHeaderHeight = 0;
    self.morePhoneView.estimatedSectionFooterHeight = 0;
    self.morePhoneView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.morePhoneView.dataSource = self;
    self.morePhoneView.delegate = self;
    self.morePhoneView.showsVerticalScrollIndicator = NO;
    self.morePhoneView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.morePhoneView registerNib:[UINib nibWithNibName:NSStringFromClass([RCAddPhoneCell class]) bundle:nil] forCellReuseIdentifier:AddPhoneCell];
}
#pragma mark -- 点击事件
- (void)batchReportClicked
{
    RCBatchReportVC *rvc = [RCBatchReportVC new];
    [self.navigationController pushViewController:rvc animated:YES];
}
- (IBAction)reportBtnClicked:(UIButton *)sender {
    hx_weakify(self);
    if (sender.tag == 1) {
        RCWishHouseVC *hvc = [RCWishHouseVC new];
        [self.navigationController pushViewController:hvc animated:YES];
        self.houses = @[@"",@"",@""];
        self.houseViewHeight.constant = 50.f+44.f*self.houses.count;
        [self.houseTableView reloadData];
    }else if (sender.tag == 2) {
        [self.phones addObject:@""];
        self.morePhoneViewHeight.constant = 50.f*self.phones.count;
        [self.morePhoneView reloadData];
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
    } else{
        RCReportPersonVC *pvc = [RCReportPersonVC new];
        [self.navigationController pushViewController:pvc animated:YES];
    }
}
- (IBAction)reportClicked:(UIButton *)sender {
    RCReportResultVC *rvc = [RCReportResultVC  new];
    [self.navigationController pushViewController:rvc animated:YES];
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == self.houseTableView)?self.houses.count:self.phones.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.houseTableView) {
        RCFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:FilterCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cate.text = @"选择的楼盘";
        return cell;
    }else{
        RCAddPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:AddPhoneCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        hx_weakify(self);
        cell.cutBtnCall = ^{
            hx_strongify(weakSelf);
            [strongSelf.phones removeLastObject];
            strongSelf.morePhoneViewHeight.constant = 50.f*strongSelf.phones.count;
            [tableView reloadData];
        };
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return (tableView == self.houseTableView)?44.f:50.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
