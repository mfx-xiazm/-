//
//  RCOpenArea.m
//  XFT
//
//  Created by 夏增明 on 2019/9/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCOpenArea.h"

@implementation RCOpenArea
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"desc"  : @"description",
//             @"ID" : @"id",
//             };
//}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"city":[RCOpenCity class]};
}
@end

@implementation RCOpenCity

@end
