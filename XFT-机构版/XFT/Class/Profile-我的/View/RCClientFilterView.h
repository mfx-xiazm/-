//
//  RCClientFilterView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCClientFilterView;

#pragma mark - 协议
@protocol RCClientFilterViewDelegate <NSObject>

@optional
//点击事件
- (void)filterDidConfirm:(RCClientFilterView *)filter beginTime:(NSString *)begin endTime:(NSString *)end;

@end


@interface RCClientFilterView : UIView
/* 目标控制器 */
@property (nonatomic,weak) UIViewController *target;

@property (nonatomic, weak) id<RCClientFilterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
