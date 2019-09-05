//
//  UILabel+HXNExtension.m
//  HX
//
//  Created by hxrc on 16/11/12.
//  Copyright © 2016年 xgt. All rights reserved.
//

#import "UILabel+HXNExtension.h"

@implementation UILabel (HXNExtension)
// 改变某些文字颜色
-(void)setColorAttributedText:(NSString *)allStr andChangeStr:(NSString *)changeStr andColor:(UIColor *)color
{
    NSString *string = changeStr;//要单独改变的字体颜色
    NSRange range = [allStr rangeOfString:string];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = attStr;
}
// 改变某些文字颜色
-(void)setColorAttributedText:(NSString *)allStr andChangeRange:(NSRange )range andColor:(UIColor *)color
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = attStr;
}

// 改变某些文字大小
-(void)setFontAttributedText:(NSString *)allStr andChangeStr:(NSString *)changeStr andFont:(UIFont *)font
{
    NSString *string = changeStr;//要单独改变的字体颜色
    NSRange range = [allStr rangeOfString:string];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    [attStr addAttribute:NSFontAttributeName value:font range:range];
    self.attributedText = attStr;
}

-(void)setFontAttributedText:(NSString *)allStr andChangeRange:(NSRange )range andFont:(UIFont *)font
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    [attStr addAttribute:NSFontAttributeName value:font range:range];
    self.attributedText = attStr;
}

// 改变某些文字大小和颜色
-(void)setFontAndColorAttributedText:(NSString *)allStr andChangeStr:(NSString *)changeStr andColor:(UIColor *)color andFont:(UIFont *)font
{
    NSString *string = changeStr;//要单独改变的字体颜色
    NSRange range = [allStr rangeOfString:string];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attStr addAttribute:NSFontAttributeName value:font range:range];
    self.attributedText = attStr;
}

-(void)setTextWithLineSpace:(CGFloat)lineSpace withString:(NSString*)str withFont:(UIFont*)font {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    
//    // 添加表情
//    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//    // 表情图片
//    attch.image = [UIImage imageNamed:@"d_aini"];
//    // 设置图片大小
//    attch.bounds = CGRectMake(0, 0, 32, 32);
//    
//    // 创建带有图片的富文本
//    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
//    [attri appendAttributedString:string];
    
    self.attributedText = attributeStr;
    
    //将lineBreakMode样式改回在末尾显示省略号的样式
    self.lineBreakMode = NSLineBreakByTruncatingTail;
}

-(void)setLabelUnderline:(NSString *)str
{
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:str attributes:attribtDic];
    
    // 赋值
    self.attributedText = attribtStr;
}
@end
