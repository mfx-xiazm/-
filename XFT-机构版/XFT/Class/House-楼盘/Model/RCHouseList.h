//
//  RCHouseList.h
//  XFT
//
//  Created by 夏增明 on 2019/9/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCHouseList : NSObject
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * headpic;
@property (nonatomic, strong) NSString * geoAreaName;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * tag;
@property (nonatomic, strong) NSString * commissionRules;
@property (nonatomic, strong) NSString * watchCount;
@property (nonatomic, strong) NSString * huXingName;
@property (nonatomic, strong) NSString * roomArea;
@property (nonatomic, strong) NSString * buldType;
@property (nonatomic, strong) NSString * longitude;//纬度
@property (nonatomic, strong) NSString * dimension;//经度
@end

NS_ASSUME_NONNULL_END
