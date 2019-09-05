//
//  MSUserInfo.h
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSUserInfo : NSObject
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *token;
/** 1 运营中心 2运营商 3 尊享VIP 4尊享 */
@property (nonatomic,copy) NSString *ulevel;
@property (nonatomic,copy) NSString *share_code;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *business;
@property (nonatomic,copy) NSString *phone;
@end
