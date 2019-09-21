//
//  RCHouseNews.h
//  XFT
//
//  Created by 夏增明 on 2019/9/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCHouseNews : NSObject
@property (nonatomic, assign) NSInteger activityNum;
@property (nonatomic, strong) NSString * cityUuid;
@property (nonatomic, assign) NSInteger clickNum;
@property (nonatomic, strong) NSString * context;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger editTime;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, assign) NSInteger favoriteNum;
@property (nonatomic, strong) NSString * headPic;
@property (nonatomic, assign) NSInteger newsType;
@property (nonatomic, strong) NSString * proUuid;
@property (nonatomic, strong) NSString * proName;
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, assign) NSInteger shareNum;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, assign) NSInteger viewType;
@end

NS_ASSUME_NONNULL_END
