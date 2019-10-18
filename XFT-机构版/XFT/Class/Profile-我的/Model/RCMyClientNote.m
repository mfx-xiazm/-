//
//  RCMyClientNote.m
//  XFT
//
//  Created by 夏增明 on 2019/10/8.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyClientNote.h"

@implementation RCMyClientNote
-(void)setTime:(NSString *)time
{
    if ([time integerValue]>0) {
        _time = [time getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"];
    }else{
        _time = @"";
    }
}
@end
