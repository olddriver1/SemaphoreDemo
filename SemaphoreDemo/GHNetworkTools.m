//
//  GHNetworkTools.m
//  SemaphoreDemo
//
//  Created by 郭杭 on 17/3/1.
//  Copyright © 2017年 郭杭. All rights reserved.
//

#import "GHNetworkTools.h"

@implementation GHNetworkTools
+ (instancetype)sharedTools {
    static dispatch_once_t onceToken;
    static GHNetworkTools *instabce;
    dispatch_once(&onceToken, ^{
        instabce = [[self alloc]init];
        NSURL *url = [NSURL URLWithString:@"http://wanquan.belightinnovation.com/"];
        instabce = [[GHNetworkTools alloc] initWithBaseURL:url];
        instabce.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"application/xml", @"text/plain",nil];
    });
    return instabce;
}

- (void)request:(GHHttpMethod)method urlString:(NSString *)urlString parameters:(id)parameters completion:(void (^)(id, NSError *))completion {
    // 请求成功的block
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        completion(responseObject, nil);
    };
    // 请求失败的block
    void(^failureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        completion(nil, error);
    };
    if (method == GHHttpMethodGet) {
        //GET
        [self GET:urlString parameters:parameters progress:nil success:successBlock failure:failureBlock];
    }else {
        //POST
        [self POST:urlString parameters:parameters progress:nil success:successBlock failure:failureBlock];
    }
}
@end
