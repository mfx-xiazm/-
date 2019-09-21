//
//  RCHouseBanner.h
//  XFT
//
//  Created by 夏增明 on 2019/9/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCHouseBanner : NSObject
@property (nonatomic, strong) NSString * carType;
@property (nonatomic, strong) NSString * context;
@property (nonatomic, assign) NSString *createTime;
@property (nonatomic, strong) NSString * headPic;
@property (nonatomic, strong) NSString * uuid;
/*展现方式 0:不跳转 1:新闻咨询 2:报名活动 3房源详情 4:外链H5 5:城市公告 6:视频播放*/
@property (nonatomic, assign) NSInteger viewType;
@end

NS_ASSUME_NONNULL_END
