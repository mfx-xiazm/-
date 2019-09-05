//
//  RCTimeFilterView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCTimeFilterView;
@protocol RCTimeFilterViewDelegate <NSObject>

@required
//出现位置
- (CGPoint)filter_positionInSuperView;
@optional
//点击事件
- (void)filter:(RCTimeFilterView *)filter  didSelectBtn:(NSInteger)index;
- (void)filter:(RCTimeFilterView *)filter  didSelectTextField:(UITextField *)textField;
- (void)filter:(RCTimeFilterView *)filter begin:(NSString *)beginTime end:(NSString *)endTime;
@end
typedef void(^test)(NSInteger);
@interface RCTimeFilterView : UIView
@property (nonatomic, assign ,readonly) BOOL show;
@property (nonatomic, weak) id<RCTimeFilterViewDelegate> delegate;
- (void)filterHidden;
- (void)filterShowInSuperView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
