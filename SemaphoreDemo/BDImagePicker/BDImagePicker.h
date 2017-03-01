//
//  AppDelegate.h
//  SemaphoreDemo
//
//  Created by 郭杭 on 16/11/15.
//  Copyright © 2017年 郭杭. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BDImagePickerFinishAction)(UIImage *image);

@interface BDImagePicker : NSObject

/**
 @param viewController  用于present UIImagePickerController对象
 @param allowsEditing   是否允许用户编辑图像
 */
+ (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(BDImagePickerFinishAction)finishAction;

@end
