//
//  RCCustomAnnotation.h
//  XFT
//
//  Created by 夏增明 on 2019/9/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QMapKit/QMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCCustomAnnotation : NSObject <QAnnotation>///遵守协议
/**
 *  @brief  经纬度
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/**
 *  @brief  标题
 */
@property (copy) NSString *title;

/**
 *  @brief  副标题
 */
@property (copy) NSString *subtitle;

///annotation图片
@property (nonatomic, strong) UIImage *image;


@end

NS_ASSUME_NONNULL_END
