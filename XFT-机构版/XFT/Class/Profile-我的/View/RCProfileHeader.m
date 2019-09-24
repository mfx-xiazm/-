//
//  RCProfileHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileHeader.h"

@interface RCProfileHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@end
@implementation RCProfileHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:[MSUserManager sharedInstance].curUserInfo.agentLoginInside.headpic] placeholderImage:HXGetImage(@"pic_header")];
    self.name.text = [MSUserManager sharedInstance].curUserInfo.orgInfo.name;
}
- (IBAction)infoClicked:(UIButton *)sender {
    if (self.profileHeaderClicked) {
        self.profileHeaderClicked();
    }
}

@end
