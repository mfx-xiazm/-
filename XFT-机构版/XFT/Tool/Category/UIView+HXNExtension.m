//
//  UIView+HXNExtension.m
//  HXXL
//
//  Created by hxrc on 16/12/10.
//  Copyright © 2016年 xgt. All rights reserved.
//

#import "UIView+HXNExtension.h"

@implementation UIView (HXNExtension)

-(void)setHxn_size:(CGSize)hxn_size
{
    CGRect frame = self.frame;
    frame.size = hxn_size;
    self.frame = frame;
}

-(void)setHxn_width:(CGFloat)hxn_width
{
    CGRect frame = self.frame;
    frame.size.width = hxn_width;
    self.frame = frame;
}
- (void)setHxn_height:(CGFloat)hxn_height
{
    CGRect frame = self.frame;
    frame.size.height = hxn_height;
    self.frame = frame;
}
-(void)setHxn_x:(CGFloat)hxn_x
{
    CGRect frame = self.frame;
    frame.origin.x = hxn_x;
    self.frame = frame;
}
-(void)setHxn_y:(CGFloat)hxn_y
{
    CGRect frame = self.frame;
    frame.origin.y = hxn_y;
    self.frame = frame;
}
-(void)setHxn_centerX:(CGFloat)hxn_centerX
{
    CGPoint center = self.center;
    center.x = hxn_centerX;
    self.center = center;
}
-(void)setHxn_centerY:(CGFloat)hxn_centerY
{
    CGPoint center = self.center;
    center.y = hxn_centerY;
    self.center = center;
}
-(void)setHxn_right:(CGFloat)hxn_right
{
    CGRect frame = self.frame;
    frame.origin.x = hxn_right - frame.size.width;
    self.frame = frame;
}
-(void)setHxn_bottom:(CGFloat)hxn_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = hxn_bottom - frame.size.height;
    self.frame = frame;
}
-(void)setHxn_origin:(CGPoint)hxn_origin
{
    CGRect frame = self.frame;
    frame.origin = hxn_origin;
    self.frame = frame;
}

-(CGSize)hxn_size
{
    return self.frame.size;
}
-(CGFloat)hxn_width
{
    return self.frame.size.width;
}
-(CGFloat)hxn_height
{
    return self.frame.size.height;
}
-(CGFloat)hxn_x
{
    return self.frame.origin.x;
}
-(CGFloat)hxn_y
{
    return self.frame.origin.y;
}
-(CGFloat)hxn_centerY
{
    return self.center.y;
}
-(CGFloat)hxn_centerX
{
    return self.center.x;
}
-(CGFloat)hxn_right
{
    return self.frame.origin.x + self.frame.size.width;
}
-(CGFloat)hxn_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}
-(CGPoint)hxn_origin
{
    return self.frame.origin;
}

- (BOOL)isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    // 除了判断是否有重贴，当前窗口是否是主窗口之外，还要判断是否可见
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}
+(instancetype)loadXibView
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}

-(void)bezierPathByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

-(void)setShadowWithCornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius
{
    self.layer.cornerRadius = cornerRadius;
    // 阴影颜色
    self.layer.shadowColor = shadowColor.CGColor;
    // 阴影偏移，默认(0, -3)
    self.layer.shadowOffset = shadowOffset;
    // 阴影透明度，默认0
    self.layer.shadowOpacity = shadowOpacity;
    // 阴影半径，默认3
    self.layer.shadowRadius = shadowRadius;
}


-(void)setLayerBoderWidth:(CGFloat)layerBoderWidth{
    self.layer.borderWidth = layerBoderWidth;
}
-(CGFloat)layerBoderWidth{
    return self.layer.borderWidth;
}

-(void)setLayerBoderCorner:(CGFloat)layerBoderCorner{
    self.layer.cornerRadius = layerBoderCorner;
}
-(CGFloat)layerBoderCorner{
    return self.layer.cornerRadius;
}

- (void)setBoderColor:(UIColor *)boderColor{
    self.layer.borderColor = boderColor.CGColor;
}

- (UIColor *)boderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setShadowColor:(UIColor *)shadowColor{
    [self.layer setShadowColor:shadowColor.CGColor];
}

-(UIColor *)shadowColor
{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}
- (void)setShadowRadius:(CGFloat)shadowRadius{
    [self.layer setShadowRadius:shadowRadius];
}
-(CGFloat)shadowRadius
{
    return self.layer.shadowRadius;
}
- (void)setShadowOpacity:(CGFloat)shadowOpacity{
    [self.layer setShadowOpacity:shadowOpacity];
}
-(CGFloat)shadowOpacity
{
    return self.layer.shadowOpacity;
}
- (void)setShadowOffset:(CGSize)shadowOffset{
    [self.layer setShadowOffset:shadowOffset];
}
-(CGSize)shadowOffset
{
    return self.layer.shadowOffset;
}
@end
