//
//  RCAddStoreVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCAddStoreVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "FSActionSheet.h"

@interface RCAddStoreVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *shopName;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *busnessCode;
@property (weak, nonatomic) IBOutlet UITextField *bankOpen;
@property (weak, nonatomic) IBOutlet UITextField *bankNo;
@property (weak, nonatomic) IBOutlet UITextField *legalName;
@property (weak, nonatomic) IBOutlet UITextField *legalPhone;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
@property (weak, nonatomic) IBOutlet UIImageView *legalPhoto;
/* 公司logo地址 */
@property(nonatomic,copy) NSString *companyLogoUrl;
/* 法人照片地址 */
@property(nonatomic,copy) NSString *legalPhotoUrl;
/* 选择的视图 */
@property(nonatomic,strong) UIButton *selectBtn;
@end

@implementation RCAddStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"添加门店"];
    
    SPButton *sureItem = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    sureItem.hxn_size = CGSizeMake(60, 44);
    sureItem.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [sureItem setTitleColor:HXControlBg forState:UIControlStateNormal];
    [sureItem setTitle:@"确定" forState:UIControlStateNormal];
    [sureItem addTarget:self action:@selector(sureClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sureItem];
}
#pragma mark -- 点击事件
-(void)sureClicked
{
    if (![self.shopName hasText]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入机构名称"];
        return;
    }
    if (![self.userName hasText]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入用户名"];
        return;
    }
    if (![self.busnessCode hasText]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入营业执照编码"];
        return;
    }
//    if (![self.bankOpen hasText]) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入开户行"];
//        return;
//    }
//    if (![self.bankNo hasText]) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入银行账号"];
//        return;
//    }
//    if (![self.legalName hasText]) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入法人姓名"];
//        return;
//    }
//    if (![self.legalPhone hasText]) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入法人电话"];
//        return;
//    }
//    if (!self.companyLogoUrl && !self.companyLogoUrl.length) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传公司Logo"];
//        return;
//    }
//    if (!self.legalPhotoUrl && !self.legalPhotoUrl.length) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传法人照片"];
//        return;
//    }
    [self addShopRequest];
}
- (IBAction)choosePicClicked:(UIButton *)sender {
    self.selectBtn = sender;
    
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        if (selectedIndex == 0) {
            [strongSelf awakeImagePickerController:@"1"];
        }else{
            [strongSelf awakeImagePickerController:@"2"];
        }
    }];
}
#pragma mark -- 业务请求
-(void)addShopRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"shopName"] = self.shopName.text;
    data[@"accNo"] = self.userName.text;
    data[@"businessLicenseCode"] = self.busnessCode.text;
//    data[@"bankAccNo"] = self.bankNo.text;
//    data[@"bankOpen"] = self.bankOpen.text;
//    data[@"legalPersonName"] = self.legalName.text;
//    data[@"legalPersonPhone"] = self.legalPhone.text;
//    data[@"companyLOGO"] = self.companyLogoUrl;
//    data[@"legalPersonPhoto"] = self.legalPhotoUrl;
    
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"agent/agent/organization/addShop" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf.addStoreCall) {
                    strongSelf.addStoreCall();
                }
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)upImageRequestWithImage:(UIImage *)image completedCall:(void(^)(NSString * imageUrl))completedCall
{
    [HXNetworkTool uploadImagesWithURL:HXRC_M_URL action:@"sys/sys/dict/getUploadImgReturnUrl.do" parameters:@{} name:@"file" images:@[image] fileNames:nil imageScale:0.8 imageType:@"png" progress:nil success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            completedCall(responseObject[@"data"][@"url"]);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 唤起相机
- (void)awakeImagePickerController:(NSString *)pickerType {
    if ([pickerType isEqualToString:@"1"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            if ([self isCanUseCamera]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionTop title:@"相机不可用"];
            return;
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            if ([self isCanUsePhotos]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionTop title:@"相册不可用"];
            return;
        }
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    hx_weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        hx_strongify(weakSelf);
        // 显示保存图片
        if (strongSelf.selectBtn.tag == 1) {
            strongSelf.companyLogo.contentMode = UIViewContentModeScaleAspectFill;
            [strongSelf.companyLogo setImage:info[UIImagePickerControllerEditedImage]];
            [strongSelf upImageRequestWithImage:info[UIImagePickerControllerEditedImage] completedCall:^(NSString *imageUrl) {
                strongSelf.companyLogoUrl = imageUrl;
            }];
        }else{
            strongSelf.legalPhoto.contentMode = UIViewContentModeScaleAspectFill;
            [strongSelf.legalPhoto setImage:info[UIImagePickerControllerEditedImage]];
            [strongSelf upImageRequestWithImage:info[UIImagePickerControllerEditedImage] completedCall:^(NSString *imageUrl) {
                strongSelf.legalPhotoUrl = imageUrl;
            }];
        }
    }];
}
@end
