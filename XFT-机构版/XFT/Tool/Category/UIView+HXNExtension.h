//
//  UIView+HXNExtension.h
//  HX
//
//  Created by hxrc on 16/12/10.
//  Copyright © 2016年 xgt. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  uiview的一个分类，用于简化尺寸位置等设置使得调用
 */
@interface UIView (HXNExtension)

@property (nonatomic, assign) CGSize  hxn_size;
@property (nonatomic, assign) CGFloat hxn_width;
@property (nonatomic, assign) CGFloat hxn_height;
@property (nonatomic, assign) CGFloat hxn_x;
@property (nonatomic, assign) CGFloat hxn_y;
@property (nonatomic, assign) CGFloat hxn_centerX;
@property (nonatomic, assign) CGFloat hxn_centerY;
@property (nonatomic, assign) CGFloat hxn_right;
@property (nonatomic, assign) CGFloat hxn_bottom;
@property (nonatomic, assign) CGPoint hxn_origin;

/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;
/**
 * 加载xib文件
 */
+(instancetype)loadXibView;
/**
 * 给一个视图切指定的角
 */
-(void)bezierPathByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
/**
 * 给一个视图设置阴影
 */
-(void)setShadowWithCornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius;
//- (CGFloat)x;
//- (void)setX:(CGFloat)x;
/** 在分类中声明@property, 只会生成方法的声明, 不会生成方法的实现和带有_下划线的成员变量*/

//仅仅用于设置ib  非正常属性
@property(nonatomic,assign)IBInspectable CGFloat layerBoderWidth;
@property(nonatomic,assign)IBInspectable CGFloat layerBoderCorner;
@property(nonatomic,strong)IBInspectable UIColor * boderColor;

/// 阴影 - View默认颜色ClearColor,阴影不会生效
@property (nonatomic,strong)IBInspectable UIColor *shadowColor;// 阴影颜色
@property (nonatomic,assign)IBInspectable CGFloat shadowRadius;// 阴影的圆角
@property (nonatomic,assign)IBInspectable CGFloat shadowOpacity;// 阴影透明度，默认0
@property (nonatomic,assign)IBInspectable CGSize shadowOffset;// 阴影偏移量
@end
