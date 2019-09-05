//
//  RCMoveClientHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^clientTypeCall)(void);
@interface RCMoveClientHeader : UIView
/* 分类点击 */
@property(nonatomic,copy) clientTypeCall clientTypeCall;
@end

NS_ASSUME_NONNULL_END
