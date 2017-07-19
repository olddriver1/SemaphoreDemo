//
//  ViewController.m
//  SemaphoreDemo
//
//  Created by 郭杭 on 17/3/1.
//  Copyright © 2017年 郭杭. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "GHNetworkTools.h"
#import "SKFCamera.h"
#import "GHimagePicker.h"
#import "TOCropViewController.h"
#import "PushToViewController.h"

@interface ViewController () <TOCropViewControllerDelegate>
@property (nonatomic, strong) UIImageView *cropImageview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBtn];
}

#pragma mark - 初始化按钮
- (void)setupBtn {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"打开相册" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnBntClike) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
}

#pragma mark - 监听事件 
- (void)btnBntClike {
    [GHimagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
        cropController.delegate = self;
        [self presentViewController:cropController animated:YES completion:nil];
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    self.cropImageview.image = image;
    CGRect viewFrame = [self.view convertRect:self.cropImageview.frame toView:self.navigationController.view];
    NSData *data = UIImageJPEGRepresentation(self.cropImageview.image,0.1);
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:@"图片正在上传中......"];
    
    [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:self.cropImageview.image toFrame:viewFrame completion:^{
        PushToViewController *vc = [[PushToViewController alloc] init];
        vc.cropImageview = self.cropImageview;
        
        dispatch_group_t group = dispatch_group_create();
        // 设置一个异步线程组
        dispatch_group_async(group, dispatch_queue_create("com.dispatch.test", DISPATCH_QUEUE_CONCURRENT), ^{
            // 创建一个信号量为0的信号(红灯)
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            NSString *urlString = @"file/upload";
            [[GHNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                [formData appendPartWithFileData:data name:@"file" fileName:@"imageView" mimeType:@"application/octet-stream"];
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSData class]]) {
                    responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                }
                NSLog(@"success : %@", responseObject);
                
                BOOL successbool = [responseObject[@"success"] boolValue];
                if (successbool) {
                    [SVProgressHUD dismiss];
                    // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯)
                    dispatch_semaphore_signal(sema);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error : %@", error);
                [SVProgressHUD dismiss];
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传图片失败" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
            }];
            // 以下还要进行一些其他的耗时操作
            NSLog(@"耗时操作继续进行");
            // 开启信号等待，设置等待时间为永久，直到信号的信号量大于等于1（绿灯）
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            [self presentViewController:vc animated:YES completion:nil];
        });

    }];
}

#pragma mark - 懒加载
- (UIImageView *)cropImageview {
    if (!_cropImageview) {
        _cropImageview = [[UIImageView alloc] init];
    }
    return _cropImageview;
}

@end
