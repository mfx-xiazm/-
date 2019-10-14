//
//  RCReportHouse.h
//  XFT
//
//  Created by 夏增明 on 2019/10/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCReportHouse : NSObject
@property(nonatomic,copy) NSString *proName;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *geoCityName;
@property(nonatomic,copy) NSString *geoAreaName;
@property(nonatomic,copy) NSString *price;
/* 该楼盘是否允许隐号报备 0不允许 1允许*/
@property(nonatomic,assign) NSInteger isHeidi;
/* 是否选择 */
@property(nonatomic,assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
