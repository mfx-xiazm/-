//
//  RCHouseBannerHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^bannerClickCall)(NSInteger index);
@interface RCHouseBannerHeader : UIView
/* 轮播图 */
@property(nonatomic,strong) NSArray *banners;
/* 轮播图点击 */
@property(nonatomic,copy) bannerClickCall bannerClickCall;
@end

NS_ASSUME_NONNULL_END
