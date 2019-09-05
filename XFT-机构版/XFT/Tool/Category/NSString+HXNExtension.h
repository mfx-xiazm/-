//
//  NSString+HXNExtension.h
//  HX
//
//  Created by hxrc on 17/3/17.
//  Copyright © 2017年 HX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HXNExtension)
// 判断是否为整形：
- (BOOL)isPureInt;
// 判断是否为浮点形：
- (BOOL)isPureFloat;
/** 是否是数字 */
- (BOOL)isJudgeNumber;
// 身份证号验证
- (BOOL)judgeIdentityStringValid;
// 文字高度
- (CGFloat)textHeightSize:(CGSize)maxSize font:(UIFont *)font lineSpacing:(CGFloat)lineSpace;
//日历周几转换（英文习惯-中文习惯）
- (NSString *)getChineseWeekdayFormEnglishWeekday;

- (NSDictionary *)dictionaryWithJsonString;
// 汉字、英语的拼音
- (NSString *)pinyin;
// 手机号验证
- (BOOL)validateContactNumber;
// 邮箱验证
- (BOOL)validateEmail;
// 验证银行卡号
- (BOOL)checkCardNo;
@end
