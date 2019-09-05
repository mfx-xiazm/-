//
//  HXNetworkCache.m
//  TestAFNTool
//
//  Created by hxrc on 2018/6/5.
//  Copyright © 2018年 xzm. All rights reserved.
//

#import "HXNetworkCache.h"
#import "YYCache.h"

static NSString *const kPPNetworkResponseCache = @"kPPNetworkResponseCache";

static YYCache *_dataCache;

@implementation HXNetworkCache

+ (void)initialize {
    _dataCache = [YYCache cacheWithName:kPPNetworkResponseCache];
}

+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)parameters filtrationCacheKey:(NSArray *)filtrationCacheKey{
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters filtrationCacheKey:filtrationCacheKey];
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:httpData forKey:cacheKey withBlock:nil];
}

+ (id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters filtrationCacheKey:(NSArray *)filtrationCacheKey{
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters filtrationCacheKey:filtrationCacheKey];
    return [_dataCache objectForKey:cacheKey];
}

+ (NSInteger)getAllHttpCacheSize {
    return [_dataCache.diskCache totalCost];
}

+ (void)removeAllHttpCache {
    [_dataCache.diskCache removeAllObjects];
}

+ (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters filtrationCacheKey:(NSArray *)filtrationCacheKey{
    if(!parameters || parameters.count == 0){return URL;};
    
    if (filtrationCacheKey && filtrationCacheKey.count) {
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [mutableParameters removeObjectsForKeys:filtrationCacheKey];
        parameters =  [mutableParameters copy];
    }

    // 将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%@%@",URL,paraString];
}

@end
