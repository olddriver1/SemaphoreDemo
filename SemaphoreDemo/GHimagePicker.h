//
//  GHimagePicker.h
//  GHimagePicker
//
//  Created by 郭杭 on 17/4/27.
//  Copyright © 2017年 郭杭. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GHImagePickerFinishAction)(UIImage *image);

@interface GHimagePicker : NSObject
/**
 @param viewController  用于present UIImagePickerController对象
 @param allowsEditing   是否允许用户编辑图像
 */
+ (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(GHImagePickerFinishAction)finishAction;
@end
