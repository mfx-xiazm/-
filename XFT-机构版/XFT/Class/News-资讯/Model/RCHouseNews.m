//
//  RCHouseNews.m
//  XFT
//
//  Created by 夏增明 on 2019/9/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseNews.h"

@implementation RCHouseNews
-(void)setPublishTime:(NSString *)publishTime
{
   _publishTime = [publishTime getTimeFromTimestamp:@"YYYY-MM-dd HH:mm"];
}
@end
