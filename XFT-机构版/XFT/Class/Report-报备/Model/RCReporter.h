//
//  RCReporter.h
//  XFT
//
//  Created by 夏增明 on 2019/10/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCReporter : NSObject
@property(nonatomic,copy) NSString *shopuuid;//门店uuid
@property(nonatomic,copy) NSString *shopname;//门店名称
@property(nonatomic,copy) NSString *accMuuid;//门店管理uuid
@property(nonatomic,copy) NSString *accMname;//门店管理姓名
@property(nonatomic,copy) NSString *orguuid;//机构id
@property(nonatomic,copy) NSString *orgname;//机构名称
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
