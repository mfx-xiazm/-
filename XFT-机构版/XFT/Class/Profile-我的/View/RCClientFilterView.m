//
//  RCClientFilterView.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientFilterView.h"
#import "RCSearchTagCell.h"
#import "RCSearchTagHeader.h"
#import "RCClientFilterTimeView.h"
#import <ZLCollectionViewVerticalLayout.h>
#import <zhPopupController.h>
#import "WSDatePickerView.h"
#import "RCMyClientFilter.h"

static NSString *const SearchTagCell = @"SearchTagCell";
static NSString *const SearchTagHeader = @"SearchTagHeader";
static NSString *const ClientFilterTimeView = @"ClientFilterTimeView";

@interface RCClientFilterView ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) UITextField *reportBeginTime;
@property (weak, nonatomic) UITextField *reportEndTime;
@property (weak, nonatomic) UITextField *visitBeginTime;
@property (weak, nonatomic) UITextField *visitEndTime;
//是否显示
@property (nonatomic, assign) BOOL show;
@end
@implementation RCClientFilterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagCell class]) bundle:nil] forCellWithReuseIdentifier:SearchTagCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCClientFilterTimeView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ClientFilterTimeView];
}
-(void)setFilterModel:(RCMyClientFilter *)filterModel
{
    _filterModel = filterModel;
    
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1) {
        // 门店  项目报备人
        
        // 初始化选中
        for (RCMyFilterModel *model in _filterModel.storeList) {
            if (model.isSelected) {
                _filterModel.selectStore = model;
                break;
            }
        }
        for (RCMyFilterModel *model in _filterModel.reporter) {
            if (model.isSelected) {
                _filterModel.selectReporter = model;
                break;
            }
        }
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {
        // 只有时间
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        // 中介经纪人
        for (RCMyFilterModel *model in _filterModel.brokerList) {
            if (model.isSelected) {
                _filterModel.selectBroker = model;
                break;
            }
        }
    }else{
        // 只有时间
    }
    
    [self.collectionView reloadData];
}
- (IBAction)resetClicked:(UIButton *)sender {

    // 清空时间
    self.reportBeginTime.text = nil;
    self.reportEndTime.text = nil;
    self.visitBeginTime.text = nil;
    self.visitEndTime.text = nil;
    
    self.filterModel.reportStartStr = @"";
    self.filterModel.reportEndStr = @"";
    self.filterModel.visitStartStr = @"";
    self.filterModel.visitEndStr = @"";
    
    self.filterModel.reportStart = 0;
    self.filterModel.reportEnd = 0;
    self.filterModel.firstVisitStart = 0;
    self.filterModel.firstVisitEnd = 0;

    // 清空选择
    self.filterModel.selectStore.isSelected = NO;
    self.filterModel.selectStore = nil;
    self.filterModel.selectBroker.isSelected = NO;
    self.filterModel.selectBroker = nil;
    self.filterModel.selectReporter.isSelected = NO;
    self.filterModel.selectReporter = nil;
    
    [self.collectionView reloadData];
}
- (IBAction)confirmClicked:(UIButton *)sender {
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    if ([self.reportBeginTime hasText]) {
        NSDate *date = [formatter dateFromString:self.reportBeginTime.text];
        self.filterModel.reportStart = [date timeIntervalSince1970];
        self.filterModel.reportStartStr = self.reportBeginTime.text;
    }else{
        self.filterModel.reportStart = 0;
        self.filterModel.reportStartStr = @"";
    }
    
    if ([self.reportEndTime hasText]) {
        NSDate *date = [formatter dateFromString:self.reportEndTime.text];
        self.filterModel.reportEnd = [date timeIntervalSince1970];
        self.filterModel.reportEndStr = self.reportEndTime.text;
    }else{
        self.filterModel.reportEnd = 0;
        self.filterModel.reportEndStr = @"";
    }
    
    if ([self.visitBeginTime hasText]) {
        NSDate *date = [formatter dateFromString:self.visitBeginTime.text];
        self.filterModel.firstVisitStart = [date timeIntervalSince1970];
        self.filterModel.visitStartStr = self.visitBeginTime.text;
    }else{
        self.filterModel.firstVisitStart = 0;
        self.filterModel.visitStartStr = @"";
    }
    
    if ([self.visitEndTime hasText]) {
        NSDate *date = [formatter dateFromString:self.visitEndTime.text];
        self.filterModel.firstVisitEnd = [date timeIntervalSince1970];
        self.filterModel.visitEndStr = self.visitEndTime.text;
    }else{
        self.filterModel.firstVisitEnd = 0;
        self.filterModel.visitEndStr = @"";
    }
    
    if ([self.delegate respondsToSelector:@selector(filterDidConfirm:)]) {
        [self.delegate filterDidConfirm:self];
    }
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1) {
        // 门店  项目报备人
       return 2;
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {
        // 只有时间
        return 1;
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        // 中介经纪人
        return 1;
    }else{
        // 只有时间
        return 1;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1) {
        // 门店  项目报备人
        if (section == 0) {
            return self.filterModel.storeList.count;
        }else{
            return self.filterModel.reporter.count;
        }
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {
        // 只有时间
        return 0;
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        // 中介经纪人
        return self.filterModel.brokerList.count;
    }else{
        // 只有时间
        return 0;
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCSearchTagCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchTagCell forIndexPath:indexPath];
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1) {
        // 门店  项目报备人
        if (indexPath.section == 0) {
            RCMyFilterModel *model = self.filterModel.storeList[indexPath.item];
            cell.contentText.text = model.name;
            cell.contentText.backgroundColor = model.isSelected?HXControlBg:HXGlobalBg;
            cell.contentText.textColor = model.isSelected?[UIColor whiteColor]:[UIColor lightGrayColor];
        }else{
            RCMyFilterModel *model = self.filterModel.reporter[indexPath.item];
            cell.contentText.text = model.name;
            cell.contentText.backgroundColor = model.isSelected?HXControlBg:HXGlobalBg;
            cell.contentText.textColor = model.isSelected?[UIColor whiteColor]:[UIColor lightGrayColor];
        }
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {
        // 只有时间
        
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        // 中介经纪人
        RCMyFilterModel *model = self.filterModel.brokerList[indexPath.item];
        cell.contentText.text = model.name;
        cell.contentText.backgroundColor = model.isSelected?HXControlBg:HXGlobalBg;
        cell.contentText.textColor = model.isSelected?[UIColor whiteColor]:[UIColor lightGrayColor];
    }else{
        // 只有时间
        
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1) {
        // 门店  项目报备人
        if (indexPath.section == 0) {
            self.filterModel.selectStore.isSelected = NO;
            RCMyFilterModel *model = self.filterModel.storeList[indexPath.item];
            model.isSelected = YES;
            self.filterModel.selectStore = model;
        }else{
            self.filterModel.selectReporter.isSelected = NO;
            RCMyFilterModel *model = self.filterModel.reporter[indexPath.item];
            model.isSelected = YES;
            self.filterModel.selectReporter = model;
        }
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {
        // 只有时间
        
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        // 中介经纪人
        self.filterModel.selectBroker.isSelected = NO;
        RCMyFilterModel *model = self.filterModel.brokerList[indexPath.item];
        model.isSelected = YES;
        self.filterModel.selectBroker = model;
    }else{
        // 只有时间
        
    }
    [collectionView reloadData];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        RCSearchTagHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader forIndexPath:indexPath];
        headerView.tabText.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        headerView.locationBtn.hidden = YES;
        /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
        if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1) {
            // 门店  项目报备人
            if (indexPath.section == 0) {
                headerView.tabText.text = @"中介门店";
            }else{
                headerView.tabText.text = @"项目统一报备人";
            }
            return headerView;
        }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {
            // 只有时间
            return nil;
        }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
            // 中介经纪人
            headerView.tabText.text = @"中介经纪人";
            return headerView;
        }else{
            // 只有时间
            return nil;
        }
    }else if ([kind isEqualToString : UICollectionElementKindSectionFooter]){
        RCClientFilterTimeView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ClientFilterTimeView forIndexPath:indexPath];
        if (self.cusType == 0) {//已报备
            footerView.visitTimeView.hidden = YES;
        }else{
            footerView.visitTimeView.hidden = NO;
        }
        
        footerView.filterTimeCall = ^(UITextField * _Nonnull textField) {
            //年-月-日
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
                
                NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
                textField.text = dateString;
            }];
            datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
            datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
            datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
            [datepicker show];
        };
        
        self.reportBeginTime = footerView.reportBeginTime;
        self.reportEndTime = footerView.reportEndTime;
        self.visitBeginTime = footerView.visitBeginTime;
        self.visitEndTime = footerView.visitEndTime;
        
        footerView.reportBeginTime.text = self.filterModel.reportStartStr;
        footerView.reportEndTime.text = self.filterModel.reportEndStr;
        footerView.visitBeginTime.text = self.filterModel.visitStartStr;
        footerView.visitEndTime.text = self.filterModel.visitEndStr;
        
        /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
        if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1) {
            // 门店  项目报备人
            if (indexPath.section == 1) {
                return footerView;
            }else{
                return nil;
            }
        }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {
            // 只有时间
            return footerView;
        }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
            // 中介经纪人
            return footerView;
        }else{
            // 只有时间
            return footerView;
        }
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1) {
        // 门店  项目报备人
        if (section == 1) {
            if (self.cusType == 0) {//已报备
                return  CGSizeMake(collectionView.frame.size.width, 100);
            }else{
                return CGSizeMake(collectionView.frame.size.width, 200);
            }
        }else{
            return CGSizeZero;
        }
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {
        // 只有时间
        return CGSizeMake(collectionView.frame.size.width, 200);
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        // 中介经纪人
        return CGSizeMake(collectionView.frame.size.width, 200);
    }else{
        // 只有时间
        return CGSizeMake(collectionView.frame.size.width, 200);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1) {
        // 门店  项目报备人
        return CGSizeMake(collectionView.frame.size.width, 44);
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {
        // 只有时间
        return CGSizeZero;
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        // 中介经纪人
        return CGSizeMake(collectionView.frame.size.width, 44);
    }else{
        // 只有时间
        return CGSizeZero;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1) {
        // 门店  项目报备人
        RCMyFilterModel *model = nil;
        if (indexPath.section == 0) {
            model = self.filterModel.storeList[indexPath.item];
        }else{
            model = self.filterModel.reporter[indexPath.item];
        }
        return CGSizeMake([model.name boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 30, 30);
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {
        // 只有时间(没有item，此尺寸任意给的)
        return CGSizeMake(120, 30);
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        // 中介经纪人
        RCMyFilterModel *model = self.filterModel.brokerList[indexPath.item];
        return CGSizeMake([model.name boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 30, 30);
    }else{
        // 只有时间 (没有item，此尺寸任意给的)
        return CGSizeMake(120, 30);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(5, 15, 5, 15);
}
@end
