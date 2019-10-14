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
        _lastVistTime = @"无";
    }
}
-(void)setTransTime:(NSString *)transTime
{
    if ([transTime integerValue]>0) {
        _transTime = [transTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _transTime = @"无";
    }
}
-(void)setInvalidTime:(NSString *)invalidTime
{
    if ([invalidTime integerValue]>0) {
        _invalidTime = [invalidTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _invalidTime = @"无";
    }
}
-(void)setLastRemarkTime:(NSString *)lastRemarkTime
{
    if ([lastRemarkTime integerValue]>0) {
        _lastRemarkTime = [lastRemarkTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _lastRemarkTime = @"无";
    }
}
-(NSInteger)yuqiTime
{
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:[_vistYuqiTime integerValue]];
    // 当前的日期和给定的日期之间相差的天数
    NSInteger day = [[NSDate date] distanceInDaysToDate:myDate];
    
    return day;
}
@end
