//
//  RCClientDetailFooter.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientDetailFooter.h"
#import "HXPlaceholderTextView.h"

@interface RCClientDetailFooter ()
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;

@end
@implementation RCClientDetailFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.remark.placeholder = @"请输入报备原因（必填）";
}

@end
