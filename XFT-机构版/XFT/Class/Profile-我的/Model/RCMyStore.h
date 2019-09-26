//
//  RCMyStore.h
//  XFT
//
//  Created by 夏增明 on 2019/9/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyStore : NSObject
@property (nonatomic, strong) NSString * managerName;
@property (nonatomic, strong) NSString * managerPhone;
@property (nonatomic, assign) NSInteger reportNum;
@property (nonatomic, strong) NSString * shopName;
@property (nonatomic, strong) NSString * shopPic;
@property (nonatomic, assign) NSInteger signNum;
@property (nonatomic, assign) NSInteger subscriptionNum;
@property (nonatomic, assign) NSInteger visitNum;
@end

NS_ASSUME_NONNULL_END
