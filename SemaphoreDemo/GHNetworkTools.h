//
//  GHNetworkTools.h
//  SemaphoreDemo
//
//  Created by 郭杭 on 17/3/1.
//  Copyright © 2017年 郭杭. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef NS_ENUM(NSUInteger, GHHttpMethod) {
    GHHttpMethodGet,
    GHHttpMethodPost,
};

@interface GHNetworkTools : AFHTTPSessionManager

// 单例
+ (instancetype)sharedTools;
// 请求网络方法
- (void)request:(GHHttpMethod)method urlString:(NSString *)urlString parameters:(id)parameters completion:(void(^)(id response, NSError *error))completion;

@end
