//
//  RCMyClientDetail.m
//  XFT
//
//  Created by 夏增明 on 2019/10/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyClientDetail.h"
#import "NSDate+HXNExtension.h"

@implementation RCMyClientDetail

-(void)setLastVistTime:(NSString *)lastVistTime
{
    if ([lastVistTime integerValue]>0) {
        _lastVistTime = [lastVistTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _lastVistTime = @"";
    }
}
-(void)setTransTime:(NSString *)transTime
{
    if ([transTime integerValue]>0) {
        _transTime = [transTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _transTime = @"";
    }
}
-(void)setInvalidTime:(NSString *)invalidTime
{
    if ([invalidTime integerValue]>0) {
        _invalidTime = [invalidTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _invalidTime = @"";
    }
}
-(void)setLastRemarkTime:(NSString *)lastRemarkTime
{
    if ([lastRemarkTime integerValue]>0) {
        _lastRemarkTime = [lastRemarkTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _lastRemarkTime = @"";
    }
}
-(NSInteger)yuqiTime
{
//    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:[_baobeiYuqiTime integerValue]];
//    // 当前的日期和给定的日期之间相差的天数
//    NSInteger day = [[NSDate date] distanceInDaysToDate:myDate]+1;//日历计算
//    return day;
    
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval currentDateInt = [currentDate timeIntervalSince1970];
//    return ceil(([_baobeiYuqiTime integerValue]-currentDateInt)/(3600*24));//向上取整
    return floor(([_baobeiYuqiTime integerValue]-currentDateInt)/(3600*24));//向下取整
}
@end
