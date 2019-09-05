//
//  RCShareView.h
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^shareTypeCall)(NSInteger type,NSInteger index);
@interface RCShareView : UIView
/* 分享类型 */
@property(nonatomic,copy) shareTypeCall shareTypeCall;
@end

NS_ASSUME_NONNULL_END
