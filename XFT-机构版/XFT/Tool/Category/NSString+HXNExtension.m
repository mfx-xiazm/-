//
//  NSString+HXNExtension.m
//  HX
//
//  Created by hxrc on 17/3/17.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "NSString+HXNExtension.h"

@implementation NSString (HXNExtension)
//判断是否为整形：
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//身份证好验证
- (BOOL)judgeIdentityStringValid {
    
    if (self.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:self]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

/**
 是否是数字
 */
- (BOOL)isJudgeNumber
{
    if (self == nil || [self length] <= 0)
    {
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (![self isEqualToString:filtered])
    {
        return NO;
    }
    return YES;
}

//日历周几转换（英文习惯-中文习惯）
- (NSString *)getChineseWeekdayFormEnglishWeekday
{
    switch ([self integerValue]) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            return @"周日";
            break;
    }
}

/**
 *  把格式化的JSON格式的字符串转换成字典
 *
 *  @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString{
    if (self == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData  options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//计算文本的高度：
- (CGFloat)textHeightSize:(CGSize)maxSize font:(UIFont *)font lineSpacing:(CGFloat)lineSpace {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace;//行间距
    
    // NSKernAttributeName 字间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    
    CGFloat textH = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    return textH;
}

//汉字、英语的拼音
- (NSString *)pinyin
{
    NSMutableString *str = [self mutableCopy];
    NSMutableString *strResult = [NSMutableString string];
    NSArray *array = @[@"掠",@"略",@"锊"];
    
    for (int i=0; i<str.length; i++)
    {
        NSString *subStr = [str substringWithRange:NSMakeRange(i, 1)];
        BOOL flag = NO;
        for (int j= 0 ; j<array.count; j++)
        {
            if ([subStr isEqualToString:array[j]])
            {
                flag = YES;
            }
        }
        
        if (flag)
        {
            subStr = @"l";
        }
        else
        {
            NSMutableString *subStr1 = [NSMutableString stringWithString:subStr];
            CFStringTransform(( CFMutableStringRef)subStr1, NULL, kCFStringTransformToLatin, NO);
            CFStringTransform((CFMutableStringRef)subStr1, NULL, kCFStringTransformStripDiacritics, NO);
            subStr = subStr1;
        }
        [strResult appendFormat:@"%@",subStr];
    }
    
    /*多音字处理*/
    if ([[str substringToIndex:1] compare:@"长"] == NSOrderedSame)
    {
        [strResult replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    if ([[str substringToIndex:1] compare:@"沈"] == NSOrderedSame)
    {
        [strResult replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    if ([[str substringToIndex:1] compare:@"厦"] == NSOrderedSame)
    {
        [strResult replaceCharactersInRange:NSMakeRange(0, 3) withString:@"xia"];
    }
    if ([[str substringToIndex:1] compare:@"地"] == NSOrderedSame)
    {
        [strResult replaceCharactersInRange:NSMakeRange(0, 3) withString:@"di"];
    }
    if ([[str substringToIndex:1] compare:@"重"] == NSOrderedSame)
    {
        [strResult replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    
    return [[strResult stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
}

- (BOOL)validateContactNumber{
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:self];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:self];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:self];
    
    if (isMatch1 || isMatch2 || isMatch3) {
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
   return [pre evaluateWithObject:self];//此处返回的是BOOL类型,YES or NO;
}
// 验证银行卡号
- (BOOL)checkCardNo{
    NSString *cardNo = self;
    
    if (cardNo.length < 15) {
        return NO;
    }
    int oddsum = 0;//奇数求和
    int evensum = 0;//偶数求和
    
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}
@end
