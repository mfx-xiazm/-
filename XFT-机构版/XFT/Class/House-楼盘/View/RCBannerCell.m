//
//  RCBannerCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBannerCell.h"
#import "RCHouseBanner.h"
#import "RCHousePicInfo.h"

@implementation RCBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setBanner:(RCHouseBanner *)banner
{
    _banner = banner;
    [self.contentImg sd_setImageWithURL:[NSURL URLWithString:_banner.headPic]];
}
-(void)setPicInfo:(RCHousePicInfo *)picInfo
{
    _picInfo = picInfo;
    [self.contentImg sd_setImageWithURL:[NSURL URLWithString:_picInfo.url]];

    if (_picInfo.type == RCHousePicInfoTypeVR) {
        self.bannerTagImg.hidden = NO;
        self.bannerTagImg.image = HXGetImage(@"icon_vr");
    }else if (_picInfo.type == RCHousePicInfoTypeVideo) {
        self.bannerTagImg.hidden = NO;
        self.bannerTagImg.image = HXGetImage(@"icon_shipin");
    }else{
        self.bannerTagImg.hidden = YES;
    }
}
@end
