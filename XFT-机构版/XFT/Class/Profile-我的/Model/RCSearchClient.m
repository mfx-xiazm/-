//
//  RCSearchClient.m
//  XFT
//
//  Created by 夏增明 on 2019/10/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCSearchClient.h"

@implementation RCSearchClient
-(void)setCreateTime:(NSString *)createTime
{
    if ([createTime integerValue]>0) {
        _createTime = [createTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _createTime = @"";
    }
}
-(void)setTime:(NSString *)time
{
    if ([time integerValue]>0) {
        _time = [time getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _time = @"";
    }
}
-(void)setLastVistTime:(NSString *)lastVistTime
{
    if ([lastVistTime integerValue]>0) {
        _lastVistTime = [lastVistTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _lastVistTime = @"";
    }
}
-(void)setSeeTime:(NSString *)seeTime
{
    if ([seeTime integerValue]>0) {
        _seeTime = [seeTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _seeTime = @"";
    }
}
@end
