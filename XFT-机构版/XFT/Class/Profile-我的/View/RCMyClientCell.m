//
//  RCMyClientCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyClientCell.h"
#import "RCClientCodeView.h"
#import <zhPopupController.h>

@implementation RCMyClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clientBtnClicked:(UIButton *)sender {
    
    RCClientCodeView *codeView = [RCClientCodeView loadXibView];
    codeView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 255.f);
    hx_weakify(self);
    codeView.closeBtnCall = ^{
        [weakSelf.target.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
    };
    self.target.zh_popupController = [[zhPopupController alloc] init];
    self.target.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.target.zh_popupController presentContentView:codeView duration:0.25 springAnimated:NO];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

