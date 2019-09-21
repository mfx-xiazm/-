//
//  RCHouseFilterData.h
//  XFT
//
//  Created by 夏增明 on 2019/9/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RCHouseFilterDistrict,RCHouseFilterService,RCHouseFilterStyle,RCHouseFilterArea;
@interface RCHouseFilterData : NSObject
@property (nonatomic, strong) NSArray<RCHouseFilterArea *> * areaType;
@property (nonatomic, strong) NSArray<RCHouseFilterService *> * buldType;
@property (nonatomic, strong) NSArray<RCHouseFilterDistrict *> * countryList;
@property (nonatomic, strong) NSArray<RCHouseFilterStyle *> * hxType;
@end

@interface RCHouseFilterDistrict : NSObject
@property (nonatomic, strong) NSString * cityName;
@property (nonatomic, strong) NSString * cityUuid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * uuid;
@end

@interface RCHouseFilterService : NSObject
@property (nonatomic, strong) NSString * dictCode;
@property (nonatomic, strong) NSString * dictName;
@property (nonatomic, strong) NSString * parentDictCode;
@end

@interface RCHouseFilterStyle : NSObject
@property (nonatomic, strong) NSString * dictCode;
@property (nonatomic, strong) NSString * dictName;
@property (nonatomic, strong) NSString * parentDictCode;
@end

@interface RCHouseFilterArea : NSObject
@property (nonatomic, strong) NSString * dictCode;
@property (nonatomic, strong) NSString * dictName;
@property (nonatomic, strong) NSString * parentDictCode;
@end

NS_ASSUME_NONNULL_END
