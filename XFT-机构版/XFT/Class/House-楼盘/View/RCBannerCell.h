//
//  RCBannerCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCHouseBanner;
@interface RCBannerCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bannerTagImg;
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
/* banner */
@property(nonatomic,strong) RCHouseBanner *banner;
@end

NS_ASSUME_NONNULL_END
