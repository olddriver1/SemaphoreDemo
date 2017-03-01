//
//  PushToViewController.m
//  SemaphoreDemo
//
//  Created by 郭杭 on 17/3/1.
//  Copyright © 2017年 郭杭. All rights reserved.
//

#import "pushToViewController.h"
#import "Masonry.h"

@interface PushToViewController ()

@end

@implementation PushToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.cropImageview];
    [_cropImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载
- (UIImageView *)cropImageview
{
    if (!_cropImageview) {
        _cropImageview = [[UIImageView alloc] init];
        _cropImageview.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _cropImageview;
}

@end
