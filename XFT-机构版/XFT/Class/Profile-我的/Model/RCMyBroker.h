//
//  RCMyBroker.h
//  XFT
//
//  Created by 夏增明 on 2019/9/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyBroker : NSObject
@property (nonatomic, strong) NSString * accUuid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * regPhone;
@property (nonatomic, assign) NSInteger  reportingNum;
@property (nonatomic, assign) NSInteger  signingNum;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, assign) NSInteger  subscriptionNum;
@property (nonatomic, assign) NSInteger  visitNum;
@end

NS_ASSUME_NONNULL_END
