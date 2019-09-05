//
//  RCNavBarView.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNavBarView.h"

@interface RCNavBarView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation RCNavBarView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backBtn.tintColor = [UIColor whiteColor];
    self.bgView.alpha = 0;
    self.titleL.hidden = YES;
}

- (void)changeColor:(UIColor *)color offsetHeight:(CGFloat)height withOffsetY:(CGFloat)offsetY {
    
    if (offsetY<=0) {
        self.titleL.hidden = YES;
    }else{
        self.titleL.hidden = NO;
    }
    
    if (offsetY < 0) {
        //下拉时导航栏隐藏
        self.hidden = YES;
        self.bgView.alpha = 0;
    }else {
        self.hidden = NO;
        //计算透明度，180为随意设置的偏移量临界值
        CGFloat scale = offsetY / height > 1.0f ? 1 : (offsetY / height);
        CGFloat red = 1 + (69/255.0 - 1) * scale;
        CGFloat green = 1 + (69/255.0 - 1) * scale;
        CGFloat blue = 1 + (69/255.0 - 1) * scale;
        
        self.backBtn.tintColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        self.titleL.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        
        self.bgView.alpha = scale;
    }
}
- (IBAction)backClicked:(id)sender {
    if (self.navBackCall) {
        self.navBackCall();
    }
}
@end
