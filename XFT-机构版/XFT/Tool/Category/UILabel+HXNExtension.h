//
//  UILabel+HXNExtension.h
//  HX
//
//  Created by hxrc on 16/11/12.
//  Copyright © 2016年 xgt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (HXNExtension)
// 改变某些文字颜色
-(void)setColorAttributedText:(NSString *)allStr andChangeStr:(NSString *)changeStr andColor:(UIColor *)color;
// 改变某些文字颜色
-(void)setColorAttributedText:(NSString *)allStr andChangeRange:(NSRange )range andColor:(UIColor *)color;

// 改变某些文字大小
-(void)setFontAttributedText:(NSString *)allStr andChangeStr:(NSString *)changeStr andFont:(UIFont *)font;
// 改变某些文字大小
-(void)setFontAttributedText:(NSString *)allStr andChangeRange:(NSRange )range andFont:(UIFont *)font;

// 改变某些文字大小和颜色
-(void)setFontAndColorAttributedText:(NSString *)allStr andChangeStr:(NSString *)changeStr andColor:(UIColor *)color andFont:(UIFont *)font;

-(void)setTextWithLineSpace:(CGFloat)lineSpace withString:(NSString*)str withFont:(UIFont*)font;

// 添加中划线
-(void)setLabelUnderline:(NSString *)str;


@end
