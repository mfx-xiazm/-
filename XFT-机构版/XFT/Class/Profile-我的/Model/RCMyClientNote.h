//
//  RCMyClientNote.h
//  XFT
//
//  Created by 夏增明 on 2019/10/8.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyClientNote : NSObject
@property (nonatomic, assign) NSInteger type;//转介类型(0报备 1到访 2跟进 3认筹 4认购 5签约 6退房 7失效 8分配 9转移)
@property (nonatomic, strong) NSString * context;//备注
@property (nonatomic, strong) NSString * cusUuid;
@property (nonatomic, strong) NSString * time;//时间

@end

NS_ASSUME_NONNULL_END
