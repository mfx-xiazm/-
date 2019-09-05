//
//  RCSearchTagHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/8/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^resetLocationCall)(void);
@interface RCSearchTagHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *tabText;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
/* 重新定位 */
@property(nonatomic,copy) resetLocationCall resetLocationCall;
@end

NS_ASSUME_NONNULL_END
