//
//  RCHouseFilterView.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseFilterView.h"
#import "HXDropMenuView.h"
#import <JXCategoryView.h>

@interface RCHouseFilterView ()<HXDropMenuDelegate,HXDropMenuDataSource,JXCategoryViewDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *areaImg;
@property (weak, nonatomic) IBOutlet UILabel *wuyeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wuyeImg;
@property (weak, nonatomic) IBOutlet UILabel *huxingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *huxingImg;
@property (weak, nonatomic) IBOutlet UILabel *mianjiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mianjiImg;

/** 过滤 */
@property (nonatomic,strong) HXDropMenuView *menuView;
/** 选择的哪一个分类 */
@property (nonatomic,strong) UIButton *selectBtn;

@end
@implementation RCHouseFilterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.menuView = [[HXDropMenuView alloc] init];
    self.menuView.dataSource = self;
    self.menuView.delegate = self;
    self.menuView.titleColor = UIColorFromRGB(0x131D2D);
    self.menuView.titleHightLightColor = UIColorFromRGB(0xFF9F08);
    
    self.categoryView.titles = @[@"住宅", @"商办"];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.averageCellSpacingEnabled = NO;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.titleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.categoryView.cellSpacing = 45.f;
    self.categoryView.contentEdgeInsetLeft = 20.f;
    self.categoryView.titleColor = UIColorFromRGB(0x666666);
    self.categoryView.titleSelectedColor = UIColorFromRGB(0x333333);
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 14.f;
    lineView.indicatorCornerRadius = 0.f;
    lineView.indicatorHeight = 6.f;
    lineView.indicatorWidthIncrement = 6.f;
    lineView.indicatorColor = HXRGBAColor(255, 159, 8, 0.6);
    self.categoryView.indicators = @[lineView];
}

- (IBAction)filterClicked:(UIButton *)sender {
    if (self.menuView.show) {
        [self.menuView menuHidden];
        return;
    }
    self.selectBtn = sender;
    if (sender.tag == 1) {
        self.menuView.transformImageView = self.areaImg;
        self.menuView.titleLabel = self.areaLabel;
    }else if (sender.tag == 2){
        self.menuView.transformImageView = self.wuyeImg;
        self.menuView.titleLabel = self.wuyeLabel;
    }else if (sender.tag == 3){
        self.menuView.transformImageView = self.huxingImg;
        self.menuView.titleLabel = self.huxingLabel;
    }else{
        self.menuView.transformImageView = self.mianjiImg;
        self.menuView.titleLabel = self.mianjiLabel;
    }
    
    if (self.tableView.contentOffset.y < (10.f+170.f)) {
        //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        self.tableView.contentOffset = CGPointMake(0, (10.f+170.f));
        //        hx_weakify(self);
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.menuView menuShowInSuperView:self.target.view];
        //        });
    }else{
        [self.menuView menuShowInSuperView:self.target.view];
    }
}

#pragma mark -- menuDelegate
- (CGPoint)menu_positionInSuperView {
    return CGPointMake(0, 100);
}
-(NSString *)menu_titleForRow:(NSInteger)row {
    if (self.selectBtn.tag == 1) {
        return self.areas[row];
    }else if (self.selectBtn.tag == 2) {
        return self.wuye[row];
    }else if (self.selectBtn.tag == 3) {
        return self.huxing[row];
    }else{
        return self.mianji[row];
    }
}
-(NSInteger)menu_numberOfRows {
    if (self.selectBtn.tag == 1) {
        return self.areas.count;
    }else if (self.selectBtn.tag == 2) {
        return self.wuye.count;
    }else if (self.selectBtn.tag == 3) {
        return self.huxing.count;
    }else{
        return self.mianji.count;
    }
}
- (void)menu:(HXDropMenuView *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.HouseFilterCall) {
        self.HouseFilterCall(self.selectBtn.tag, indexPath.row);
    }
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    //这里关心点击选中的回调！！！
    
}

@end
