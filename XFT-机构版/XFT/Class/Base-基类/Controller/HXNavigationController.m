//
//  HXNavigationController.m
//  HX
//
//  Created by hxrc on 17/3/2.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "HXNavigationController.h"
#import "UIImage+HXNExtension.h"

@interface HXNavigationController ()<UIGestureRecognizerDelegate>
/** 手势 */
@property (nonatomic,strong) UIPanGestureRecognizer * fullScreenGes;
@end

@implementation HXNavigationController

/**
 * 当第一次使用这个类的时候会调用一次，如果放在viewDidLoad里面则会调用多次
 */
+ (void)initialize
{
    // 当导航栏用在HXNavigationController中, appearance设置才会生效
//    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    // 第一句只会在当前导航栏生效，第二句全部生效
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = UIColorFromRGB(0xFFFFFF);
    bar.translucent = NO;
    [bar setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xFFFFFF) size:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage imageWithColor:UIColorFromRGB(0xFFFFFF) size:CGSizeMake(1, 1)]];
    //    如果如下设置，则所有的导航栏控制器都会生效，并不仅仅限于本导航栏控制器
    //    UINavigationBar *bar = [UINavigationBar appearance];
    //    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    // 统一设置导航栏标题文字的大小
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName : UIColorFromRGB(0x1A1A1A)}];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    // 如果滑动移除控制器的功能失效，清空代理(让导航控制器重新设置这个功能)
//    self.interactivePopGestureRecognizer.delegate = nil;

    //  这句很核心 稍后讲解
    id target = self.interactivePopGestureRecognizer.delegate;
    //  这句很核心 稍后讲解
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    //  创建pan手势 作用范围是全屏
    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    self.fullScreenGes = fullScreenGes;
    [targetView addGestureRecognizer:fullScreenGes];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
}
#pragma mark - UIGestureRecognizerDelegate
//  防止导航控制器只有一个rootViewcontroller时触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    // 解决右滑和UITableView左滑删除的冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return self.childViewControllers.count == 1 ? NO : YES;
}
/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        
        //如果不是第一个控制器，那push就隐藏掉tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 如果push进来的不是第一个控制器，就设置其左边的返回键
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        button.hxn_size = CGSizeMake(44, 44);
        // 让按钮内部的所有内容左对齐
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
