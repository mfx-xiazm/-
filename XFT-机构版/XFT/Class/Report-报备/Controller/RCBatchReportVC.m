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
#import "RCAddClientCell.h"
#import "WSDatePickerView.h"
#import "RCReportPersonVC.h"
#import "RCReportResultVC.h"
#import "RCHouseTagsCell.h"
#import <ZLCollectionViewHorzontalLayout.h>

static NSString *const FilterCell = @"FilterCell";
static NSString *const AddClientCell = @"AddClientCell";
static NSString *const HouseTagsCell = @"HouseTagsCell";

@interface RCBatchReportVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreClientViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *moreClientTableView;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UITextField *appointDate;
@property (weak, nonatomic) IBOutlet UIView *reportPersonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reportPersonViewHeight;
/* 选择的楼盘 */
@property(nonatomic,strong) NSArray *houses;
/* 多加的客户 */
@property(nonatomic,strong) NSMutableArray *clients;

@end

@implementation RCBatchReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"批量报备"];
    self.remark.placeholder = @"请输入补充说明(选填)";
    [self setUpTableView];
    [self setUpCollectionView];
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
-(void)setUpCollectionView
{
    ZLCollectionViewHorzontalLayout *flowLayout = [[ZLCollectionViewHorzontalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseTagsCell class]) bundle:nil] forCellWithReuseIdentifier:HouseTagsCell];
}
#pragma mark -- 点击事件
- (IBAction)reportBtnClicked:(UIButton *)sender {
    hx_weakify(self);
    if (sender.tag == 1) {
        RCWishHouseVC *hvc = [RCWishHouseVC new];
        [self.navigationController pushViewController:hvc animated:YES];
        self.houses = @[@"",@"",@""];
        self.houseViewHeight.constant = 50.f+60.f;
        hx_weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
        });
    }else if (sender.tag == 2) {
        [self.clients addObject:@""];
        self.moreClientViewHeight.constant = 110.f*self.clients.count;
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
    return self.clients.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCAddClientCell *cell = [tableView dequeueReusableCellWithIdentifier:AddClientCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    hx_weakify(self);
    cell.cutBtnCall = ^{
        hx_strongify(weakSelf);
        [strongSelf.clients removeLastObject];
        strongSelf.moreClientViewHeight.constant = 110.f*strongSelf.clients.count;
        [tableView reloadData];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 110.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.houses.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ColumnLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseTagsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:HouseTagsCell forIndexPath:indexPath];
    cell.name.text = @"选择的楼盘名称";
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([@"选择的楼盘名称" boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 50, 30);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(15, 15, 15, 15);
}
@end
