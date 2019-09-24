//
//  RCHousePic.m
//  XFT
//
//  Created by 夏增明 on 2019/9/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHousePic.h"

@implementation RCHousePic
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"videoCover"  : @"videoPic",
             @"vrCover" : @"vrPic",
             };
}
-(void)setPicUrl:(NSString *)picUrl
{
    _picUrl = picUrl;
    if (_picUrl.length) {
        _picUrls = [_picUrl componentsSeparatedByString:@","];
    }else{
        _picUrls = [NSArray array];
    }
}
@end
