//
//  RCClientCodeView.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientCodeView.h"
#import "WSLNativeScanTool.h"

@interface RCClientCodeView ()
@property (weak, nonatomic) IBOutlet UIView *fillView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;

@end
@implementation RCClientCodeView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    [self bezierPathByRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
    
    self.codeImg.image =  [WSLNativeScanTool createQRCodeImageWithString:@"来一个二维码" andSize:self.codeImg.hxn_size andBackColor:[UIColor whiteColor] andFrontColor:[UIColor blackColor] andCenterImage:nil];
}
- (IBAction)closeBtnClicked:(UIButton *)sender {
    if (self.closeBtnCall) {
        self.closeBtnCall();
    }
}

- (IBAction)fillSureClicked:(UIButton *)sender {
    self.fillView.hidden = YES;
    self.codeView.hidden = NO;
}

@end
