//
//  RCNewsDetailVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNewsDetailVC.h"
#import "RCShareView.h"
#import <zhPopupController.h>
#import <WebKit/WebKit.h>
#import "RCHouseNews.h"

@interface RCNewsDetailVC ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebView     *webView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
/* 资讯详情 */
@property(nonatomic,strong) RCHouseNews *newsDetail;
@end

@implementation RCNewsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"资讯详情"];
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.contentView addSubview:self.webView];
    [self getNewsDetailRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.contentView.bounds;
}
- (WKWebView *)webView{
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        //        preference.minimumFontSize = 16;
        //        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        //        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preference;
        
        _webView = [[WKWebView alloc] initWithFrame:self.contentView.bounds configuration:configuration];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = YES;
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    
    return _webView;
}
#pragma mark -- 数据请求
-(void)getNewsDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"uuid"] = self.newsUuid;
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/News/findOneById" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            hx_strongify(weakSelf);
            strongSelf.newsDetail = [RCHouseNews yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 刷新界面
                [strongSelf handleNewsData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleNewsData
{
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = UIColorFromRGB(0x1A1A1A);
    title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    title.text = self.newsDetail.title;
    CGFloat textHeight = [self.newsDetail.title textHeightSize:CGSizeMake(HX_SCREEN_WIDTH-15*2, CGFLOAT_MAX) font:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium] lineSpacing:5.f];
    title.frame = CGRectMake(15, 0, HX_SCREEN_WIDTH-15*2, textHeight);
    [header addSubview:title];
    
    UILabel *time = [[UILabel alloc] init];
    time.textColor = UIColorFromRGB(0x666666);
    time.font = [UIFont systemFontOfSize:14];
    time.text = self.newsDetail.publishTime;
    time.frame = CGRectMake(15, CGRectGetMaxY(title.frame)+10, HX_SCREEN_WIDTH-15*2, 20);
    [header addSubview:time];

    header.frame = CGRectMake(0, -(CGRectGetMaxY(time.frame)+10), HX_SCREEN_WIDTH, CGRectGetMaxY(time.frame)+10);

    [self.webView.scrollView addSubview:header];
    
    self.webView.scrollView.contentInset = UIEdgeInsetsMake((CGRectGetMaxY(time.frame)+10), 0, 0, 0);
    
    NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:15px 15px;color:#666666}</style></head><body>%@</body></html>",self.newsDetail.context];
    [self.webView loadHTMLString:h5 baseURL:nil];
}
#pragma mark -- 点击事件
-(IBAction)shareClicked
{
    RCShareView *share = [RCShareView loadXibView];
    share.hxn_width = HX_SCREEN_WIDTH;
    share.hxn_height = 260.f;
    hx_weakify(self);
    share.shareTypeCall = ^(NSInteger type, NSInteger index) {
        if (type == 1) {
            if (index == 1) {
                HXLog(@"微信好友");
            }else if (index == 2) {
                HXLog(@"朋友圈");
            }else{
                HXLog(@"链接");
            }
        }else{
            [weakSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:share duration:0.25 springAnimated:NO];
}
-(IBAction)collectClicked
{
    HXLog(@"收藏");

}
- (IBAction)lookHouseDetail:(UIButton *)sender {
    HXLog(@"楼盘详情");
}
#pragma mark -- WKWebView UI代理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
   // [self stopShimmer];
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
   // [self stopShimmer];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
   // [self stopShimmer];
}
// 在JS端调用alert函数时(警告弹窗)，会触发此代理方法。
// 通过completionHandler()回调JS
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// JS端调用confirm函数时(确认、取消式弹窗)，会触发此方法
// completionHandler(true)返回结果
// JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// JS调用prompt函数(输入框)时回调，completionHandler回调结果
// JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    /*
     当用户点击网页上的链接，需要打开新页面时，将先调用这个方法 -(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
     
     这个方法的参数 WKNavigationAction 中有两个属性：sourceFrame和targetFrame，分别代表这个action的出处和目标。类型是 WKFrameInfo 。WKFrameInfo有一个 mainFrame 的属性，正是这个属性标记着这个frame是在主frame里还是新开一个frame。
     
     如果 targetFrame 的 mainFrame 属性为NO，表明这个 WKNavigationAction 将会新开一个页面。此时开发者需要实现本方法，返回一个新的WKWebView，让 WKNavigationAction 在新的webView中打开
     */
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
@end
