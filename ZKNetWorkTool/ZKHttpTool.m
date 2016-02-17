//
//  HttpTool.m
//  test
//
//  Created by lee on 16/2/1.
//  Copyright © 2016年 sanchun. All rights reserved.
//
/*
#define kDEBUG 0

#if kDEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif
*/

#import "ZKHttpTool.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "JDStatusBarNotification.h"
@implementation ZKHttpTool
+(ZKHttpTool *)sharedHttpTool
{
    static ZKHttpTool *httpTool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        httpTool = [[self alloc]init];
    });
    return httpTool;
}
-(AFHTTPSessionManager *)jsonManager
{
    if (_jsonManager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _jsonManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    }
    return _jsonManager;
}

+(AFNetworkReachabilityStatus)reachability
{
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                [JDStatusBarNotification showWithStatus:@"未识别的网络"  dismissAfter:3.0f styleName:JDStatusBarStyleDark];
                NSLog(@"未识别的网络");
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
            {
                [JDStatusBarNotification showWithStatus:@"不可达的网络(未连接)"  styleName:JDStatusBarStyleWarning];
                NSLog(@"不可达的网络(未连接)");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [JDStatusBarNotification dismissAnimated:YES];
                NSLog(@"2G,3G,4G...的网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
               [JDStatusBarNotification dismissAnimated:YES];
                NSLog(@"wifi的网络");
                break;
            }
            default:
                break;
        }
    }];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}
+(void)httpToolGETWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure
{
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    AFHTTPSessionManager *manager = [ZKHttpTool sharedHttpTool].jsonManager;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain" ,@"text/html" ,nil];
    
//    NSURLRequest *request = [[AFHTTPRequestSerializer serializer]requestWithMethod:@"GET" URLString:urlString parameters:params error:nil];
//    
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        success(responseObject);
//        if (error) {
//            failure(error);
//        }
//    }];
//    
//    [dataTask resume];
   
    
    [manager GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}
+(void)httpToolPOSTWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure
{
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    AFHTTPSessionManager *manager = [ZKHttpTool sharedHttpTool].jsonManager;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain" ,@"text/html" ,nil];
    
//    NSURLRequest *request = [[AFHTTPRequestSerializer serializer]requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
//    
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        success(responseObject);
//        if (error) {
//            failure(error);
//        }
//    }];
//
//    [dataTask resume];
    
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}

+(void)httpToolDataTaskWithURL:(NSString *)urlString  success:(Success)success failure:(Failure)failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
             failure(error);
        } else {
            success(responseObject);
        }
    }];
    [dataTask resume];
}
+(void)httpToolDownImageWithURL:(NSString *)urlString success:(Success)success failure:(Failure)failure
{
    [self httpToolDataTaskWithURL:urlString success:^(id responseObject) {
        UIImage *img = [[UIImage alloc]initWithData:responseObject];
        success(img);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
@end































