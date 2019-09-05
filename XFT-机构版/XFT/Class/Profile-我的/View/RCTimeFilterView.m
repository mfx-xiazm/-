//
//  RCTimeFilterView.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTimeFilterView.h"

@interface RCTimeFilterView ()<UIGestureRecognizerDelegate>
//是否显示
@property (nonatomic, assign) BOOL show;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *beginTime;
@property (weak, nonatomic) IBOutlet UITextField *endTime;

@end
@implementation RCTimeFilterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    //事件
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterHidden)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.contentView]) {// isDescendantOfView 前者是否是后者的子视图
        // 如果点击的是子视图就不响应点击事件
        return NO;
    }
    return YES;
}
- (IBAction)resetTimeClicked:(UIButton *)sender {
    self.beginTime.text = nil;
    self.endTime.text = nil;
}
- (IBAction)filterTimeClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(filter:didSelectTextField:)]) {
        [self.delegate filter:self didSelectTextField:(sender.tag == 1)?self.beginTime:self.endTime];
    }
}

- (IBAction)sureBtnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(filter:begin:end:)]) {
        [self.delegate filter:self begin:self.beginTime.text end:self.endTime.text];
    }
}

#pragma mark - 触发下拉事件
- (void)filterShowInSuperView:(UIView *)view {
    if (!_show) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(filter_positionInSuperView)]) {
            CGPoint position = [self.delegate filter_positionInSuperView];
            self.frame = CGRectMake(position.x, position.y, HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT - position.y);
        } else {
            self.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT);
        }
        [view addSubview:self];
    }
    hx_weakify(self);
    [UIView animateWithDuration:0.2 animations:^{
        hx_strongify(weakSelf);
        strongSelf.backgroundColor = strongSelf.show ? [UIColor colorWithWhite:0.0 alpha:0.0] : [UIColor colorWithWhite:0.0 alpha:0.20];
//        if (strongSelf.transformImageView) {
//            strongSelf.transformImageView.transform = strongSelf.show ? CGAffineTransformMakeRotation(0) : CGAffineTransformMakeRotation(M_PI);
//        }
    } completion:^(BOOL finished) {
        hx_strongify(weakSelf);
        if (strongSelf.show) {
            [strongSelf removeFromSuperview];
        }
        strongSelf.show = !strongSelf.show;
    }];
}

#pragma mark - 触发收起事件
- (void)filterHidden {
    if (_show) {
        hx_weakify(self);
        [UIView animateWithDuration:0.2 animations:^{
            hx_strongify(weakSelf);
            strongSelf.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
//            if (strongSelf.transformImageView) {
//                strongSelf.transformImageView.transform = CGAffineTransformMakeRotation(0);
//            }
        } completion:^(BOOL finished) {
            hx_strongify(weakSelf);
            strongSelf.show = !strongSelf.show;
            [strongSelf removeFromSuperview];
        }];
    }
}
@end
