//
//  HXGuideViewController.m
//  KYPX
//
//  Created by hxrc on 17/8/17.
//  Copyright © 2017年 KY. All rights reserved.
//

#import "HXGuideViewController.h"
//#import "BBLoginVC.h"
//#import "HXNavigationController.h"

#define HWNewfeatureCount 3
@interface HXGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation HXGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建一个scrollView：显示所有的新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 2.添加图片到scrollView中
    CGFloat scrollW = scrollView.frame.size.width;
    CGFloat scrollH = scrollView.frame.size.height;
    for (int i = 0; i<HWNewfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*scrollW, 0, scrollW, scrollH);
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"引导页_%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 如果是最后一个imageView，就往里面添加其他内容
        if (i == HWNewfeatureCount - 1)
        {
            [self setupLastImageView:imageView];
        }
    }
    // 3.设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.contentSize = CGSizeMake(HWNewfeatureCount * scrollW, 0);
    scrollView.bounces = NO; // 去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    /* 引导页图片上已经有了pageControl
     // 4.添加pageControl：分页，展示目前看的是第几页
     UIPageControl *pageControl = [[UIPageControl alloc] init];
     pageControl.numberOfPages = HWNewfeatureCount;
     pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:253/255.0 green:98/255.0 blue:42/255.0 alpha:1];
     pageControl.pageIndicatorTintColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1];
     pageControl.center = CGPointMake(scrollW * 0.5, scrollH - 50);
     [self.view addSubview:pageControl];
     self.pageControl = pageControl;
     */
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
     double page = scrollView.contentOffset.x / scrollView.frame.size.width;
     // 四舍五入计算出页码
     self.pageControl.currentPage = (int)(page + 0.5);
     */
    // 1.3四舍五入 1.3 + 0.5 = 1.8 强转为整数(int)1.8= 1
    // 1.5四舍五入 1.5 + 0.5 = 2.0 强转为整数(int)2.0= 2
    // 1.6四舍五入 1.6 + 0.5 = 2.1 强转为整数(int)2.1= 2
    // 0.7四舍五入 0.7 + 0.5 = 1.2 强转为整数(int)1.2= 1
}

/**
 *  初始化最后一个imageView
 *
 *  @param imageView 最后一个imageView
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    // 开启交互功能
    imageView.userInteractionEnabled = YES;
    
    // 进入应用
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startClick)];
    [imageView addGestureRecognizer:tap];
    /*
     UIButton *startBtn = [[UIButton alloc] init];
     startBtn.frame = CGRectMake(self.view.bounds.size.width/2-100/2, imageView.frame.size.height*0.75, 100, 30);
     [startBtn setTitle:@"进入应用" forState:UIControlStateNormal];
     [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
     [imageView addSubview:startBtn];
     */
}

/*
-(void)setupExit:(UIImageView *)imageView
{
    // 开启交互功能
    imageView.userInteractionEnabled = YES;
    UIButton *exitButton = [ZzqUITools createButton:CGRectMake(HX_SCREEN_WIDTH-80, HXTopHeight+10, 60, 24) andTarget:self andSeletor:@selector(startClick) andTitleColor:UIColorFromRGB(0xFE5282) andFont:[UIFont systemFontOfSize:13] andBackGroundColor:[UIColor clearColor] andBackGroundImage:nil andTitle:@"跳过"];
    HXViewBorderRadius(exitButton, 12, 1, UIColorFromRGB(0xFE5282));
    [imageView addSubview:exitButton];
}
 */


- (void)startClick
{
    // 切换到HWTabBarController
    /*
     切换控制器的手段
     1.push：依赖于UINavigationController，控制器的切换是可逆的，比如A切换到B，B又可以回到A
     2.modal：控制器的切换是可逆的，比如A切换到B，B又可以回到A
     3.切换window的rootViewController
     */
//    BBLoginVC *lvc = [BBLoginVC new];
//    HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:lvc];
//    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
//
//    //推出主界面出来
//    CATransition *ca = [CATransition animation];
//    ca.type = @"movein";
//    ca.duration = 0.5;
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
