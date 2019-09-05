//
//  RCWishHouseFilterView.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCWishHouseFilterView.h"
#import <JXCategoryView.h>

@interface RCWishHouseFilterView ()<JXCategoryViewDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@end
@implementation RCWishHouseFilterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.averageCellSpacingEnabled = NO;
    self.categoryView.titles = @[@"新房", @"公寓"];
    self.categoryView.titleColor = [UIColor lightGrayColor];
    self.categoryView.titleSelectedColor = UIColorFromRGB(0xFF9F08);
    self.categoryView.delegate = self;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 10;
    lineView.indicatorColor = UIColorFromRGB(0xFF9F08);
    self.categoryView.indicators = @[lineView];
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    //这里关心点击选中的回调！！！
    
}

@end
