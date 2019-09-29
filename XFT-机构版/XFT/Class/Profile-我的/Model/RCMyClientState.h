//
//  RCMyClientState.h
//  XFT
//
//  Created by 夏增明 on 2019/9/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyClientState : NSObject
/* 数量 */
@property(nonatomic,copy) NSString *num;
/* 名字 */
@property(nonatomic,copy) NSString *name;
/* 用户状态id */
@property(nonatomic,assign) NSInteger cusType;
@end

NS_ASSUME_NONNULL_END
