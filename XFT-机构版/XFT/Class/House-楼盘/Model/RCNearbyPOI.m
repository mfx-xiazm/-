//
//  RCNearbyPOI.m
//  XFT
//
//  Created by 夏增明 on 2019/9/23.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNearbyPOI.h"

@implementation RCNearbyPOI
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"adInfo":[RCNearbyAdInfo class],
             @"location":[RCNearbyLocation class]
             };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
@end

@implementation RCNearbyAdInfo

@end

@implementation RCNearbyLocation

@end
