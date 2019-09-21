//
//  RCUserAeraManager.h
//  XFT
//
//  Created by 夏增明 on 2019/9/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCUserArea.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCUserAeraManager : NSObject
+ (instancetype)sharedInstance;
/** 当前用户选择的位置信息 */
@property (nonatomic, strong) RCUserArea *curUserArea;
-(void)saveUserArea;
-(BOOL)loadUserArea;
@end

NS_ASSUME_NONNULL_END
