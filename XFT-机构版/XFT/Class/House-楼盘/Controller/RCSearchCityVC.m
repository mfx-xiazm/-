//
//  RCSearchCityVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCSearchCityVC.h"
#import "HXSearchBar.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "RCSearchTagCell.h"
#import "RCSearchTagHeader.h"
#import <JXCategoryView.h>
#import "RCOpenArea.h"

#define KFilePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"kSearchCityHistory.plist"]

static NSString *const SearchTagCell = @"SearchTagCell";
static NSString *const SearchTagHeader = @"SearchTagHeader";

@interface RCSearchCityVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate,JXCategoryViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *categorySuperView;
/** 存放每一组的布局 */
@property (nonatomic, strong) NSArray <UICollectionViewLayoutAttributes *> *sectionHeaderAttributes;
/** 搜索历史 */
@property (nonatomic,strong) NSMutableArray *citys;
/** 搜索历史 */
@property (nonatomic,strong) NSMutableArray *historys;
/** 工具条 */
@property (nonatomic, strong) JXCategoryTitleView *pinCategoryView;
/* 关键词 */
@property(nonatomic,copy) NSString *keyWord;
/* 搜索结果 */
@property(nonatomic,strong) NSArray *searchCitys;
@end
@implementation RCSearchCityVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpUIConfig];
    [self setUpCollectionView];
    [self setUpCategoryView];
    [self getAllCitysRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.pinCategoryView.frame = self.categorySuperView.bounds;
}
-(NSMutableArray *)historys
{
    if (_historys == nil) {
        _historys = [NSMutableArray array];
    }
    return _historys;
}
-(NSMutableArray *)citys
{
    if (_citys == nil) {
        _citys = [NSMutableArray array];
    }
    return _citys;
}
#pragma mark -- 视图相关
-(void)setUpUIConfig
{
    UIView *speace = [[UIView alloc] init];
    speace.hxn_width = 1;
    speace.hxn_height = 32;
    UIBarButtonItem *speaceItem = [[UIBarButtonItem alloc] initWithCustomView:speace];
    HXSearchBar *search = [HXSearchBar searchBar];
    search.backgroundColor = UIColorFromRGB(0xf5f5f5);
    search.hxn_width = HX_SCREEN_WIDTH - 80;
    search.hxn_height = 32;
    search.layer.cornerRadius = 32/2.f;
    search.layer.masksToBounds = YES;
    search.delegate = self;
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:search];
    self.navigationItem.leftBarButtonItems = @[speaceItem,searchItem];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClickd) title:@"取消" font:[UIFont systemFontOfSize:15] titleColor:UIColorFromRGB(0xFF9F08) highlightedColor:UIColorFromRGB(0xFF9F08) titleEdgeInsets:UIEdgeInsetsZero];
}
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = HXGlobalBg;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagCell class]) bundle:nil] forCellWithReuseIdentifier:SearchTagCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader];
}
-(void)setUpCategoryView
{
    self.pinCategoryView = [[JXCategoryTitleView alloc] init];
    self.pinCategoryView.backgroundColor = [UIColor whiteColor];
    self.pinCategoryView.frame = self.categorySuperView.bounds;
    self.pinCategoryView.titleColor = [UIColor lightGrayColor];
    self.pinCategoryView.titleSelectedColor = UIColorFromRGB(0xFF9F08);
    self.pinCategoryView.delegate = self;
    
    [self.categorySuperView addSubview:self.pinCategoryView];
}
#pragma mark -- 点击事件
-(void)cancelClickd
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITextField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 发起搜索
    if ([textField hasText]) {
        self.keyWord = textField.text;
        [self getCitysWithKeywordRequest];
    }else{
        self.keyWord = nil;
        // 直接刷新回到全部
        self.pinCategoryView.hidden = NO;
        [self.collectionView reloadData];
    }
    return YES;
}
#pragma mark -- UIScrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.keyWord) {
        if (!(scrollView.isTracking || scrollView.isDecelerating)) {
            //不是用户滚动的，比如setContentOffset等方法，引起的滚动不需要处理。
            return;
        }
        //用户滚动的才处理
        //获取categoryView下面一点的所有布局信息，用于知道，当前最上方是显示的哪个section
        for (int i=0; i<self.sectionHeaderAttributes.count; i++) {
            if (i == self.sectionHeaderAttributes.count-1) {
                UICollectionViewLayoutAttributes *targetAttri = self.sectionHeaderAttributes[i];
                if (scrollView.contentOffset.y + 1 >= targetAttri.frame.origin.y) {
                    if (self.pinCategoryView.selectedIndex != i) {
                        //不相同才切换
                        [self.pinCategoryView selectItemAtIndex:i];
                    }
                    break;
                }
            }else{
                UICollectionViewLayoutAttributes *targetAttri0 = self.sectionHeaderAttributes[i];
                UICollectionViewLayoutAttributes *targetAttri1 = self.sectionHeaderAttributes[i+1];
                if ((scrollView.contentOffset.y + 1 > targetAttri0.frame.origin.y) && (scrollView.contentOffset.y + 1 < targetAttri1.frame.origin.y)) {
                    if (self.pinCategoryView.selectedIndex != i) {
                        //不相同才切换
                        [self.pinCategoryView selectItemAtIndex:i];
                    }
                    break;
                }
            }
        }
    }
}
#pragma mark -- 接口请求
/** 查询所有城市信息 */
-(void)getAllCitysRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/city/queryAllCityInfo" parameters:@{} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            
            [weakSelf readHistorySearch];

            NSArray *citys = [NSArray yy_modelArrayWithClass:[RCOpenArea class] json:responseObject[@"data"]];
            [weakSelf.citys addObjectsFromArray:citys];
            NSMutableArray *temp = [NSMutableArray array];
            for (RCOpenArea *area in weakSelf.citys) {
                [temp addObject:area.areaName];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
                weakSelf.pinCategoryView.titles = temp;
                [weakSelf.pinCategoryView reloadData];//刷新数组布局
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf updateSectionHeaderAttributes];//存放每组的布局
                });
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 模糊查询城市信息 */
-(void)getCitysWithKeywordRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"name"] = self.keyWord;
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/city/cityByLike" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            NSArray *result = [NSArray yy_modelArrayWithClass:[RCOpenCity class] json:responseObject[@"data"]];
            RCOpenArea *searchArea = [RCOpenArea new];
            searchArea.areaName = @"搜索结果";
            searchArea.city = result;
            weakSelf.searchCitys = @[searchArea];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.pinCategoryView.hidden = YES;
            [weakSelf.collectionView reloadData];
        });
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 业务逻辑
- (void)updateSectionHeaderAttributes {
    //获取到所有的sectionHeaderAtrributes，用于后续的点击，滚动到指定contentOffset.y使用
    NSMutableArray *attributes = [NSMutableArray array];
    UICollectionViewLayoutAttributes *lastHeaderAttri = nil;
    for (int i = 0; i < self.citys.count; i++) {
        UICollectionViewLayoutAttributes *attri = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        if (attri) {
            [attributes addObject:attri];
        }
        if (i == self.citys.count - 1) {
            lastHeaderAttri = attri;
        }
    }
    if (attributes.count == 0) {
        return;
    }
    self.sectionHeaderAttributes = attributes;
    //如果最后一个section条目太少了，会导致滚动最底部，但是却不能触发categoryView选中最后一个item。而且点击最后一个滚动的contentOffset.y也不要弄。所以添加contentInset，让最后一个section滚到最下面能显示完整个屏幕。
    UICollectionViewLayoutAttributes *lastCellAttri = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:((RCOpenArea *)self.citys[self.citys.count - 1]).city.count - 1 inSection:self.citys.count - 1]];
    CGFloat lastSectionHeight = CGRectGetMaxY(lastCellAttri.frame) - CGRectGetMinY(lastHeaderAttri.frame);
    CGFloat value = self.collectionView.bounds.size.height - lastSectionHeight;
    if (value > 0) {
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, value, 0);
    }
}
-(void)readHistorySearch
{
    RCOpenArea *dwArea = [RCOpenArea new];
    dwArea.areaName = @"定位城市";
    RCOpenCity *dwCity = [RCOpenCity new];
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:HXUserCityName];
    if (city && city.length) {
        dwCity.cname = city;
    }else{
        dwCity.cname = @"未知";
    }
    dwArea.city = @[dwCity];
    [self.citys addObject:dwArea];
    
    // 判断是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:KFilePath] == NO) {
        HXLog(@"不存在");
        // 一、使用NSMutableArray来接收plist里面的文件
        //        plistArr = [[NSMutableArray alloc] init];
    } else {
        HXLog(@"存在");
        // 使用NSArray来接收plist里面的文件，获取里面的数据
        NSArray *arr = [NSArray arrayWithContentsOfFile:KFilePath];
        if (arr.count != 0) {
            [self.historys addObjectsFromArray:arr];
            RCOpenArea *area = [RCOpenArea new];
            area.areaName = @"历史访问";
            area.city = [NSArray yy_modelArrayWithClass:[RCOpenCity class] json:self.historys];
            [self.citys addObject:area];
        } else {
            HXLog(@"plist文件为空");
        }
    }
}
-(void)writeHistorySearch
{
    [self.historys writeToFile:KFilePath atomically:YES];
    
    RCOpenArea *area = self.citys[1];
    if ([area.areaName isEqualToString:@"历史访问"]) {
        area.city = [NSArray yy_modelArrayWithClass:[RCOpenCity class] json:self.historys];
        [self.citys replaceObjectAtIndex:1 withObject:area];
    }else{
        RCOpenArea *area = [RCOpenArea new];
        area.areaName = @"历史访问";
        area.city = [NSArray yy_modelArrayWithClass:[RCOpenCity class] json:self.historys];
        [self.citys insertObject:area atIndex:1];
        
        NSMutableArray *titles = [NSMutableArray arrayWithArray:self.pinCategoryView.titles];
        [titles insertObject:@"历史访问" atIndex:1];
        self.pinCategoryView.titles = titles;
        [self.pinCategoryView reloadData];//刷新数组布局
        hx_weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf updateSectionHeaderAttributes];//存放每组的布局
        });
    }
}
-(void)checkHistoryData:(NSDictionary *)history
{
    BOOL isHaveHistory = NO;
    for (NSDictionary *dict in self.historys) {
        if ([dict[@"cname"] isEqualToString:history[@"cname"]]) {//如果历史数据包含就更新
            [self.historys removeObject:history];
            [self.historys insertObject:history atIndex:0];
            isHaveHistory = YES;
            break;
        }
    }
    if (!isHaveHistory) {//如果历史数据不包含就加
        [self.historys insertObject:history atIndex:0];
    }
    
    [self writeHistorySearch];//写入
    
    [self.collectionView reloadData];//刷新页面
}
-(void)clearClicked
{
    [self.historys removeAllObjects];
    [self writeHistorySearch];//写入
    [self.collectionView reloadData];
}
#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    //这里关心点击选中的回调！！！
    UICollectionViewLayoutAttributes *targetAttri = self.sectionHeaderAttributes[index];
    //选中了第一个，特殊处理一下，滚动到sectionHeaer的最上面
    [self.collectionView setContentOffset:CGPointMake(0, targetAttri.frame.origin.y) animated:YES];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (self.keyWord && self.keyWord.length) ?self.searchCitys.count : self.citys.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.keyWord && self.keyWord.length) {
        RCOpenArea *area = self.searchCitys[section];
        return area.city.count;
    }else{
        RCOpenArea *area = self.citys[section];
        return area.city.count;
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RCSearchTagCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchTagCell forIndexPath:indexPath];
    if (self.keyWord && self.keyWord.length) {
        RCOpenArea *area = self.searchCitys[indexPath.section];
        RCOpenCity *city = area.city[indexPath.item];
        cell.contentText.text = city.cname;
        cell.contentText.backgroundColor = [UIColor whiteColor];
        cell.contentText.textColor = [UIColor lightGrayColor];
    }else{
        RCOpenArea *area = self.citys[indexPath.section];
        RCOpenCity *city = area.city[indexPath.item];
        cell.contentText.text = indexPath.section?[NSString stringWithFormat:@"%@(%@)",city.cname,city.num]:city.cname;
        cell.contentText.backgroundColor = indexPath.section?[UIColor whiteColor]:HXControlBg;
        cell.contentText.textColor = indexPath.section?[UIColor lightGrayColor]:[UIColor whiteColor];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RCOpenArea *area = nil;
    if (self.keyWord && self.keyWord.length) {
        area = self.searchCitys[indexPath.section];
    }else{
        area = self.citys[indexPath.section];
    }
    RCOpenCity *city = area.city[indexPath.item];
    NSDictionary *dict = [city yy_modelToJSONObject];
    
    if (self.keyWord && self.keyWord.length) {
        
    }else{// 如果不是搜索结果的点击才存入历史记录
        if (indexPath.section) {// 定位城市不存入历史
            [self checkHistoryData:dict];
        }
    }
    
    RCUserArea *userArea = [RCUserArea yy_modelWithDictionary:dict];
    [RCUserAeraManager sharedInstance].curUserArea = userArea;
    [[RCUserAeraManager sharedInstance] saveUserArea];
    if (self.changeCityCall) {
        self.changeCityCall();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        RCSearchTagHeader * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader forIndexPath:indexPath];
        if (self.keyWord && self.keyWord.length) {
            RCOpenArea *area = self.searchCitys[indexPath.section];
            headerView.tabText.text = area.areaName;
            headerView.locationBtn.hidden = YES;
        }else{
            RCOpenArea *area = self.citys[indexPath.section];
            headerView.tabText.text = area.areaName;
            headerView.locationBtn.hidden = indexPath.section;
        }
        headerView.resetLocationCall = ^{
            HXLog(@"重新定位");
        };
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 44);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.keyWord && self.keyWord.length) {
        RCOpenArea *area = self.searchCitys[indexPath.section];
        RCOpenCity *city = area.city[indexPath.item];
        return CGSizeMake([city.cname boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 30, 30);
    }else{
        RCOpenArea *area = self.citys[indexPath.section];
        RCOpenCity *city = area.city[indexPath.item];
        return CGSizeMake([city.cname boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 30, 30);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(5, 15, 5, 15);
}
@end
