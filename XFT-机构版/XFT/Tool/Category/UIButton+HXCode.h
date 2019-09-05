//
//  UIButton+HXCode.h
//  HX
//
//  Created by hxrc on 16/12/10.
//  Copyright © 2016年 xgt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HXN_ActionBlock)(UIButton * _Nullable button);
typedef BOOL (^HXN_JudgeBlock)(void);

@interface UIButton (HXCode)
/**
 *  倒计时按钮
 *
 *  @param timeLine 倒计时总时间
 *  @param title    还没倒计时的title
 *  @param subTitle 倒计时中的子名字，如时、分(这里你只要传入“s后重新发送”)
 *  @param mColor   还没倒计时的颜色
 *  @param color    倒计时中的颜色
 */

- (void)startWithTime:(NSInteger)timeLine title:(NSString * _Nullable)title countDownTitle:(NSString * _Nullable)subTitle mainColor:(UIColor * _Nullable)mColor countColor:(UIColor * _Nullable)color;

/**
 *  绑定button
 **/
-(void)BindingBtnJudgeBlock:(HXN_JudgeBlock _Nonnull)judgeBlock ActionBlock:(HXN_ActionBlock _Nonnull)actionBlock;

/**
 *  加载完毕停止旋转
 *  title:停止后button的文字
 *  textColor :字体色 如果颜色不变就为nil
 *  backgroundColor :背景色 如果颜色不变就为nil
 **/

-(void)stopLoading:(NSString*_Nullable)title image:(UIImage *_Nullable)image textColor:(UIColor*_Nullable)textColor backgroundColor:(UIColor*_Nullable)backColor;

/**
 *  设置加载圆圈的宽度 默认是5
 **/
@property(nonatomic,assign)NSInteger lineWidths;


/**
 *  设置加载圆圈距离上下边距的宽度 默认是5
 **/
@property(nonatomic,assign)NSInteger topHeight;

/*
 
 注意 ：  加载的圆圈颜色渐变值默认是button的背景色和字体色；
 如果设置以下圆圈颜色渐变值 颜色就不会随着字体和背景颜色变化了
 
 */

/**
 *  设置开始加载时候的圆圈颜色渐变值 1
 **/
@property(nonatomic,strong)UIColor * _Nullable startColorOne;
/**
 *  设置开始加载时候的圆圈颜色渐变值 2
 **/
@property(nonatomic,strong)UIColor * _Nullable startColorTwo;

@end
