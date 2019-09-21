//
//  RCHouseFilterData.m
//  XFT
//
//  Created by 夏增明 on 2019/9/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseFilterData.h"

@implementation RCHouseFilterData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"areaType":[RCHouseFilterArea class],
             @"buldType":[RCHouseFilterService class],
             @"countryList":[RCHouseFilterDistrict class],
             @"hxType":[RCHouseFilterStyle class]
             };
}
@end

@implementation RCHouseFilterDistrict

@end

@implementation RCHouseFilterService

@end

@implementation RCHouseFilterStyle

@end

@implementation RCHouseFilterArea

@end
