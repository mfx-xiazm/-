//
//  RCHouseInfoVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseInfoVC.h"
#import "RCHouseDetailInfoCell.h"
#import "RCHouseInfo.h"

static NSString *const HouseDetailInfoCell = @"HouseDetailInfoCell";
@interface RCHouseInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 楼盘详情 */
@property(nonatomic,strong) RCHouseInfo *houseInfo;
/* 整理的数据机构 */
@property(nonatomic,strong) NSMutableArray *houseData;
@end

@implementation RCHouseInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"楼盘详情"];
    [self setUpTableView];
    [self getHouseInfoRequest];
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.rowHeight = UITableViewAutomaticDimension;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseDetailInfoCell class]) bundle:nil] forCellReuseIdentifier:HouseDetailInfoCell];
    
    self.tableView.hidden = YES;
}
#pragma mark -- 接口请求
-(void)getHouseInfoRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"uuid"] = self.uuid;
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/proBaseInfo/all" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
           strongSelf.houseInfo = [RCHouseInfo yy_modelWithDictionary:responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf handleHouseInfo];
        });
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleHouseInfo
{
    self.tableView.hidden = NO;
    
    UIView *header = [UIView new];
    header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60);
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    label.text = self.houseInfo.name;
    label.hxn_x = 15.f;
    label.hxn_y = 15.f;
    label.hxn_width = HX_SCREEN_WIDTH - 15*2;
    [label sizeToFit];
    [header addSubview:label];
    
    self.tableView.tableHeaderView = header;
    
    self.houseData = [NSMutableArray array];
    NSArray *titles = @[@"楼盘地址",@"楼盘状态",@"楼盘均价",@"可售面积",@"可售户型",@"开盘时间",@"交房时间",@"装修标准",@"绿化率",@"容积率",@"物业费",@"车位占比",@"规划户数",@"产权年限",@"占地面积",@"开发商",@"物业公司"];
    NSArray *values = @[self.houseInfo.buldAddr,self.houseInfo.salesState,[NSString stringWithFormat:@"%@建面约元/㎡", self.houseInfo.price],[NSString stringWithFormat:@"%@㎡", self.houseInfo.areaInterval],self.houseInfo.mainHuxingName,self.houseInfo.openTime,self.houseInfo.deliveryTime,self.houseInfo.decorate,self.houseInfo.greenRate,self.houseInfo.volumeRate,[NSString stringWithFormat:@"%@/㎡", self.houseInfo.propertyFee],self.houseInfo.carRate,[NSString stringWithFormat:@"%@户", self.houseInfo.totalUsers],[NSString stringWithFormat:@"%@年", self.houseInfo.buldYears],[NSString stringWithFormat:@"%@㎡", self.houseInfo.totalAre],self.houseInfo.buldDeveloper,self.houseInfo.propertyCompany];

    for (int i=0; i<17; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"name"] = titles[i];
        dict[@"content"] = values[i];
        [self.houseData addObject:dict];
    }
    [self.tableView reloadData];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.houseData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseDetailInfoCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.houseData[indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"%@：",dict[@"name"]];
    cell.content.text = dict[@"content"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
