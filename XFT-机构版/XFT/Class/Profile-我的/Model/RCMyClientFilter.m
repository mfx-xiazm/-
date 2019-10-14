//
//  RCMyClientFilter.m
//  XFT
//
//  Created by 夏增明 on 2019/10/8.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyClientFilter.h"

@implementation RCMyClientFilter
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"brokerList":[RCMyFilterModel class],
             @"reporter":[RCMyFilterModel class],
             @"storeList":[RCMyFilterModel class]
             };
}
@end

@implementation RCMyFilterModel

@end

