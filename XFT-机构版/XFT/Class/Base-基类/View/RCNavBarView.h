//
//  RCNavBarView.h
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^navBackCall)(void);
@interface RCNavBarView : UIView
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
- (void)changeColor:(UIColor *)color offsetHeight:(CGFloat)height withOffsetY:(CGFloat)offsetY;
/** 返回 */
@property (nonatomic,copy) navBackCall navBackCall;
@end

NS_ASSUME_NONNULL_END
