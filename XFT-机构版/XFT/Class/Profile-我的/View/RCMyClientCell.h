//
//  RCMyClientCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCMyClient;
typedef void(^clientHandleCall)(NSInteger index);
@interface RCMyClientCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *brokerView;
@property (weak, nonatomic) IBOutlet UIView *mangeView;
@property (weak, nonatomic) IBOutlet UIView *remarkView;
/* 用户状态 1到访 2认筹 3认购 4签约 5退房 6失效 7报备 */
@property(nonatomic,assign) NSInteger cusType;
/* 经理主管客户 */
@property(nonatomic,strong) RCMyClient *client;
/* 中介报备人客户 */
@property(nonatomic,strong) RCMyClient *client1;
/* 操作 */
@property(nonatomic,copy) clientHandleCall clientHandleCall;

@end

NS_ASSUME_NONNULL_END
