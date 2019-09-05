//
//  HXTopWindow.h
//  HealthyNews
//
//  Created by HX on 16/1/22.
//  Copyright © 2016年 HX. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 给状态栏添加一个按钮可以进行点击, 可以让屏幕上的scrollView滚到最顶部
 */
@interface HXTopWindow : NSObject
+ (void)show;
+ (void)hide;
@end
