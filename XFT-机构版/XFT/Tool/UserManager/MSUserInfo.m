//
//  MSUserInfo.m
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import "MSUserInfo.h"

@implementation MSUserInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"agentLoginInside":[MSUserShowInfo class],
             @"userAccessInfo":[MSUserAccessInfo class],
             @"orgInfo":[MSOrgInfoInfo class],
             @"dropValueDTOS":[MSDropValues class]
             };
}
-(NSString *)userAccessStr
{
    _userAccessInfo.domain = @"org-app-ios";
    return [_userAccessInfo yy_modelToJSONString];
}
-(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    if (!jsonData) {
        HXLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}
@end
@implementation MSUserShowInfo : NSObject

@end

@implementation MSUserAccessInfo : NSObject

@end

@implementation MSOrgInfoInfo : NSObject

@end

@implementation MSDropValues : NSObject

@end

