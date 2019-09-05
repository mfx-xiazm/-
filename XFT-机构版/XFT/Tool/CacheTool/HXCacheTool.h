//
//  HXCacheTool.h
//  baisibudejie
//
//  Created by targetcloud on 2017/3/8.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXCacheTool : NSObject
/**
 *  获取文件夹尺寸
 *
 *  @param directoryPath 文件夹路径
 *
 *  返回文件夹尺寸
 */
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion;
/**
 *  删除文件夹所有文件
 *
 *  @param directoryPath 文件夹路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;
@end
