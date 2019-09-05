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

static NSString *const SearchTagCell = @"SearchTagCell";
static NSString *const SearchTagHeader = @"SearchTagHeader";
static NSString *const ClientFilterTimeView = @"ClientFilterTimeView";

@interface RCClientFilterView ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) UITextField *beginTime;
@property (weak, nonatomic) UITextField *endTime;
//是否显示
@property (nonatomic, assign) BOOL show;
/* 测试数据 */
@property(nonatomic,strong) NSArray *testArrs;
@end
@implementation RCClientFilterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.testArrs = @[@"全部",@"武汉融公馆",@"中介门店1",@"报备人1",@"经纪人1"];
    
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
    
    self.userInteractionEnabled = YES;
    //事件
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterHidden)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    
    [self.collectionView reloadData];
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.collectionView.contentSize.height + 44.f > 500.f) {
            weakSelf.contentHeight.constant = 500.f;
        }else{
            weakSelf.contentHeight.constant = weakSelf.collectionView.contentSize.height + 44.f;
        }
    });
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.collectionView]) {// isDescendantOfView 前者是否是后者的子视图
        // 如果点击的是子视图就不响应点击事件
        return NO;
    }
    return YES;
}
- (IBAction)resetClicked:(UIButton *)sender {
    HXLog(@"重置-选项归为全部、时间清空");
}
- (IBAction)confirmClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(filterDidConfirm:beginTime:endTime:)]) {
        [self.delegate filterDidConfirm:self beginTime:self.beginTime.text endTime:self.endTime.text];
    }
}

#pragma mark - 触发下拉事件
- (void)filterShowInSuperView:(UIView *)view {
    if (!_show) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(filter_positionInSuperView)]) {
            CGPoint position = [self.delegate filter_positionInSuperView];
            self.frame = CGRectMake(position.x, position.y, HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT - position.y);
        } else {
            self.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT);
        }
        [view addSubview:self];
    }
    hx_weakify(self);
    [UIView animateWithDuration:0.2 animations:^{
        hx_strongify(weakSelf);
        strongSelf.backgroundColor = strongSelf.show ? [UIColor colorWithWhite:0.0 alpha:0.0] : [UIColor colorWithWhite:0.0 alpha:0.20];
        //        if (strongSelf.transformImageView) {
        //            strongSelf.transformImageView.transform = strongSelf.show ? CGAffineTransformMakeRotation(0) : CGAffineTransformMakeRotation(M_PI);
        //        }
    } completion:^(BOOL finished) {
        hx_strongify(weakSelf);
        if (strongSelf.show) {
            [strongSelf removeFromSuperview];
        }
        strongSelf.show = !strongSelf.show;
    }];
}

#pragma mark - 触发收起事件
- (void)filterHidden {
    if (_show) {
        hx_weakify(self);
        [UIView animateWithDuration:0.2 animations:^{
            hx_strongify(weakSelf);
            strongSelf.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            //            if (strongSelf.transformImageView) {
            //                strongSelf.transformImageView.transform = CGAffineTransformMakeRotation(0);
            //            }
        } completion:^(BOOL finished) {
            hx_strongify(weakSelf);
            strongSelf.show = !strongSelf.show;
            [strongSelf removeFromSuperview];
        }];
    }
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.testArrs.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCSearchTagCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchTagCell forIndexPath:indexPath];
    cell.contentText.text = self.testArrs[indexPath.item];
    cell.contentText.backgroundColor = HXGlobalBg;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        RCSearchTagHeader * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader forIndexPath:indexPath];
        headerView.locationBtn.hidden = YES;
        return headerView;
    }else if ([kind isEqualToString : UICollectionElementKindSectionFooter]){
        RCClientFilterTimeView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ClientFilterTimeView forIndexPath:indexPath];
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
        if (indexPath.section == 2) {
            self.beginTime = footerView.beginTime;
            self.endTime = footerView.endTime;
            return footerView;
        }else{
            return nil;
        }
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return CGSizeMake(collectionView.frame.size.width, 100);
    }else{
        return CGSizeZero;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 44);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self.testArrs[indexPath.item] boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 30, 30);
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
