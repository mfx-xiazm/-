//
//  RCMyClientDetail.h
//  XFT
//
//  Created by 夏增明 on 2019/10/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyClientDetail : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *cusPic;
@property(nonatomic,copy) NSString *sex;
@property(nonatomic,copy) NSString *lastFollowTime;
@property(nonatomic,copy) NSString *lastVistTime;
@property(nonatomic,copy) NSString *vistYuqiTime;
@property(nonatomic,assign) NSInteger cusState;
@property(nonatomic,copy) NSString *transTime;
@property(nonatomic,copy) NSString *isValid;
@property(nonatomic,copy) NSString *invalidTime;
@property(nonatomic,copy) NSString *lastRemarkTime;
@property(nonatomic,copy) NSString *remark;
@property(nonatomic,copy) NSString *salesName;
@property(nonatomic,copy) NSString *teamName;
@property(nonatomic,copy) NSString *groupName;
@property(nonatomic,copy) NSString *salesPhone;
@property(nonatomic,copy) NSString *seeTime;
@property(nonatomic,copy) NSString *twoQudaoName;
@property(nonatomic,copy) NSString *idNo;
@property(nonatomic,copy) NSString *isHidden;
@property(nonatomic,copy) NSString *baoBeiUuid;
@property(nonatomic,copy) NSString *cusUuid;
@property(nonatomic,assign) NSInteger yuqiTime;

@end

NS_ASSUME_NONNULL_END
