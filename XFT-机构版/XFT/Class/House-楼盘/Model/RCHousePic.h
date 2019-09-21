//
//  RCHousePic.h
//  XFT
//
//  Created by 夏增明 on 2019/9/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCHousePic : NSObject
@property (nonatomic, strong) NSArray<NSString *> * picUrl;
@property (nonatomic, strong) NSString * videoUrl;
@property (nonatomic, strong) NSString * vrUrl;
@property (nonatomic, strong) NSString * videoCover;
@property (nonatomic, strong) NSString * vrCover;
@end

NS_ASSUME_NONNULL_END
