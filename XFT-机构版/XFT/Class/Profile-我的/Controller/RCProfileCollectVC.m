//
//  RCProfileCollectVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileCollectVC.h"
#import "RCProfileCollectChildVC.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>

@interface RCProfileCollectVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;

@end

@implementation RCProfileCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的收藏"];
    [self setUpCategoryView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
-(NSArray *)childVCs
{
    if (_childVCs == nil) {
        NSMutableArray *vcs = [NSMutableArray array];
        for (int i=0;i<2;i++) {
            RCProfileCollectChildVC *cvc0 = [RCProfileCollectChildVC new];
            cvc0.collectType = i;
            [self addChildViewController:cvc0];
            [vcs addObject:cvc0];
        }
        _childVCs = vcs;
    }
    return _childVCs;
}
-(void)setUpCategoryView
{
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.titles = @[@"房源", @"楼盘资讯"];
    _categoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    _categoryView.titleColor = UIColorFromRGB(0x666666);
    _categoryView.titleSelectedColor = HXControlBg;
    _categoryView.delegate = self;
    _categoryView.contentScrollView = self.scrollView;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 5.f;
    lineView.indicatorColor = HXControlBg;
    _categoryView.indicators = @[lineView];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(HX_SCREEN_WIDTH*self.childVCs.count, 0);
    
    // 加第一个视图
    UIViewController *targetViewController = self.childVCs.firstObject;
    targetViewController.view.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, _scrollView.hxn_height);
    [_scrollView addSubview:targetViewController.view];
}
#pragma mark - JXCategoryViewDelegate
// 滚动和点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    // 处理侧滑手势
    //self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);

    if (self.childVCs.count <= index) {return;}
    
    UIViewController *targetViewController = self.childVCs[index];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(HX_SCREEN_WIDTH * index, 0, HX_SCREEN_WIDTH, self.scrollView.hxn_height);
    
    [self.scrollView addSubview:targetViewController.view];
}
@end
