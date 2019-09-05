//
//  RCClientFilterTimeView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^filterTimeCall)(UITextField *textField);
@interface RCClientFilterTimeView : UICollectionReusableView
/* 时间 */
@property(nonatomic,copy) filterTimeCall filterTimeCall;
@property (weak, nonatomic) IBOutlet UITextField *beginTime;
@property (weak, nonatomic) IBOutlet UITextField *endTime;
@end

NS_ASSUME_NONNULL_END
