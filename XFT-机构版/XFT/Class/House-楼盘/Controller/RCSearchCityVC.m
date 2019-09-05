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
@end
@implementation RCSearchCityVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpUIConfig];
    [self readHistorySearch];
    [self setUpCollectionView];
    [self setUpCategoryView];
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
        _citys = [NSMutableArray arrayWithArray:@[@{@"tag":@"定位城市",@"citys":@[@"武汉"]},@{@"tag":@"历史访问",@"citys":self.historys},@{@"tag":@"热门访问",@"citys":@[@"长沙",@"太原",@"武汉",@"呼和浩特",@"郑州",@"郑州",@"北京",@"长沙",@"太原",@"武汉",@"呼和浩特",@"郑州",@"郑州",@"北京",@"长沙",@"太原",@"武汉",@"呼和浩特",@"郑州",@"郑州",@"北京"]},@{@"tag":@"武汉区域",@"citys":@[@"长沙",@"呼和浩特",@"武汉",@"上海",@"郑州",@"郑州",@"北京",@"长沙",@"呼和浩特",@"武汉",@"上海",@"郑州",@"郑州",@"北京",@"长沙",@"呼和浩特",@"武汉",@"上海",@"郑州",@"郑州",@"北京"]},@{@"tag":@"上海区域",@"citys":@[@"长沙",@"太原",@"武汉",@"上海",@"郑州",@"乌鲁木齐",@"北京",@"长沙",@"太原",@"武汉",@"上海",@"郑州",@"乌鲁木齐",@"北京",@"长沙",@"太原",@"武汉",@"上海",@"郑州",@"乌鲁木齐",@"北京"]},@{@"tag":@"郑州区域",@"citys":@[@"长沙",@"太原",@"武汉",@"上海",@"郑州",@"郑州",@"北京",@"长沙",@"太原",@"武汉",@"上海",@"郑州",@"郑州",@"北京",@"长沙",@"太原",@"武汉",@"上海",@"郑州",@"郑州",@"北京"]}]];
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
    self.pinCategoryView.titles = @[@"定位城市", @"历史访问", @"热门访问", @"武汉区域", @"上海区域", @"郑州区域"];
    self.pinCategoryView.titleColor = [UIColor lightGrayColor];
    self.pinCategoryView.titleSelectedColor = UIColorFromRGB(0xFF9F08);
    self.pinCategoryView.delegate = self;
    
    [self.categorySuperView addSubview:self.pinCategoryView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateSectionHeaderAttributes];//存放每组的布局
    });
}
#pragma mark -- 点击事件
-(void)cancelClickd
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITextField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField hasText]) {
        [MBProgressHUD showOnlyTextToView:self.view title:@"请输入关键字"];
        return NO;
    }
    [textField resignFirstResponder];//放弃响应
    // 发起搜索
    
    return YES;
}
#pragma mark -- UIScrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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
#pragma mark -- 业务逻辑
- (void)updateSectionHeaderAttributes {
    if (self.sectionHeaderAttributes == nil) {
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
        UICollectionViewLayoutAttributes *lastCellAttri = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:((NSArray *)((NSDictionary *)self.citys[self.citys.count - 1])[@"citys"]).count - 1 inSection:self.citys.count - 1]];
        CGFloat lastSectionHeight = CGRectGetMaxY(lastCellAttri.frame) - CGRectGetMinY(lastHeaderAttri.frame);
        CGFloat value = self.collectionView.bounds.size.height - lastSectionHeight;
        if (value > 0) {
            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, value, 0);
        }
    }
}
-(void)readHistorySearch
{
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
        } else {
            HXLog(@"plist文件为空");
        }
    }
    [self.collectionView reloadData];
}
-(void)writeHistorySearch
{
    [self.historys writeToFile:KFilePath atomically:YES];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.citys[1]];
    dict[@"citys"] = self.historys;
    [self.citys replaceObjectAtIndex:1 withObject:dict];
//    RCSearchHouseResultVC *rvc = [RCSearchHouseResultVC new];
//    [self.navigationController pushViewController:rvc animated:YES];
}
-(void)checkHistoryData:(NSString *)history
{
    if (![self.historys containsObject:history]) {//如果历史数据不包含就加
        [self.historys insertObject:history atIndex:0];
    }else{//如果历史数据包含就更新
        [self.historys removeObject:history];
        [self.historys insertObject:history atIndex:0];
    }
    //    if (self.historys.count > 6) {
    //        [self.historys removeLastObject];
    //    }
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
    return self.citys.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *dict = self.citys[section];
    return ((NSArray *)dict[@"citys"]).count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCSearchTagCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchTagCell forIndexPath:indexPath];
    NSDictionary *dict = self.citys[indexPath.section];
    cell.contentText.text = ((NSArray *)dict[@"citys"])[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.citys[indexPath.section];
    [self checkHistoryData:((NSArray *)dict[@"citys"])[indexPath.item]];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        RCSearchTagHeader * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader forIndexPath:indexPath];
        NSDictionary *dict = self.citys[indexPath.section];
        headerView.tabText.text = dict[@"tag"];
        headerView.locationBtn.hidden = indexPath.section;
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
    NSDictionary *dict = self.citys[indexPath.section];
    return CGSizeMake([((NSArray *)dict[@"citys"])[indexPath.item] boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 30, 30);
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
