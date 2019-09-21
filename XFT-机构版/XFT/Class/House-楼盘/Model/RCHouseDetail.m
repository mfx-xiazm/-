//
//  RCHouseDetail.m
//  XFT
//
//  Created by 夏增明 on 2019/9/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseDetail.h"

@implementation RCHouseDetail
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"rhxList":[RCHouseStyle class]
             };
}
@end

@implementation RCHouseStyle

@end
