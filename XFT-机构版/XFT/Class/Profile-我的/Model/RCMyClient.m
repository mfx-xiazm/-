//
//  RCMyClient.m
//  XFT
//
//  Created by 夏增明 on 2019/9/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyClient.h"

@implementation RCMyClient

-(void)setEditTime:(NSString *)editTime
{
    if ([editTime integerValue]>0) {
        _editTime = [editTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _editTime = @"无";
    }
}
-(void)setCreateTime:(NSString *)createTime
{
    if ([createTime integerValue]>0) {
        _createTime = [createTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _createTime = @"无";
    }
}
- (void)setRemarkTime:(NSString *)remarkTime
{
    if ([remarkTime integerValue]>0) {
        _remarkTime = [remarkTime getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _remarkTime = @"无";
    }
}

@end
