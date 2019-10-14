//
//  RCMyClientCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCMyClient,RCSearchClient;
typedef void(^clientHandleCall)(NSInteger index);
@interface RCMyClientCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *brokerView;
@property (weak, nonatomic) IBOutlet UIView *mangeView;
@property (weak, nonatomic) IBOutlet UIView *remarkView;
/* 用户状态 0:已报备 2:已到访 4:已认筹 5:已认购 6:已签约 7:已退房 100:已失效 (默认状态为:0) */
@property(nonatomic,assign) NSInteger cusType;
/* 项目名称 */
@property(nonatomic,strong) NSString *proName;
/* 客户 */
@property(nonatomic,strong) RCMyClient *client;
/* 搜索客户 */
@property(nonatomic,strong) RCSearchClient *searchClient;
/* 操作 */
@property(nonatomic,copy) clientHandleCall clientHandleCall;

@end

NS_ASSUME_NONNULL_END
