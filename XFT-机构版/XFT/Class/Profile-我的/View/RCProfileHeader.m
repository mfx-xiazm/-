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
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1) {
        self.name.text = [NSString stringWithFormat:@"%@主机构",[MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName];
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 2) {
        self.name.text = [NSString stringWithFormat:@"%@统一报备员",[MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName];
    }else if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        self.name.text = [NSString stringWithFormat:@"%@子机构",[MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName];
    }else {
        self.name.text = [NSString stringWithFormat:@"%@子机构经纪人",[MSUserManager sharedInstance].curUserInfo.orgUserInfo.orgName];
    }
}
- (IBAction)infoClicked:(UIButton *)sender {
    if (self.profileHeaderClicked) {
        self.profileHeaderClicked();
    }
}

@end
