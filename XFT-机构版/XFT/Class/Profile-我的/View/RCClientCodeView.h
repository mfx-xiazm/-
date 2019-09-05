//
//  RCClientCodeView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^closeBtnCall)(void);
@interface RCClientCodeView : UIView
/* 关闭点击 */
@property(nonatomic,copy) closeBtnCall closeBtnCall;
@end

NS_ASSUME_NONNULL_END
