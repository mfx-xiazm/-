//
//  RCUserAeraManager.m
//  XFT
//
//  Created by 夏增明 on 2019/9/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCUserAeraManager.h"
#import <YYCache.h>
#import <YYModel.h>

//用户信息存储键
#define KUserAreaCacheName @"KBBAreaUserCacheName"
#define KUserAreaModelCache @"KBBAreaUserModelCache"

static RCUserAeraManager *_instance = nil;
static YYCache *_cache = nil;
@implementation RCUserAeraManager
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
        _cache = [[YYCache alloc] initWithName:KUserAreaCacheName];
    });
    return _instance;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
#pragma mark ————— 储存用户信息 —————
-(void)saveUserArea{
    if (self.curUserArea) {
        NSDictionary *dic = [self.curUserArea yy_modelToJSONObject];
        [_cache setObject:dic forKey:KUserAreaModelCache];
    }
}

#pragma mark ————— 加载缓存的用户信息 —————
-(BOOL)loadUserArea{
    NSDictionary * userDic = (NSDictionary *)[_cache objectForKey:KUserAreaModelCache];
    if (userDic) {
        self.curUserArea = [RCUserArea yy_modelWithJSON:userDic];
        return YES;
    }
    return NO;
}
@end
