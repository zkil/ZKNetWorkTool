//
//  HttpTool.h
//  test
//
//  Created by lee on 16/2/1.
//  Copyright © 2016年 sanchun. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Config.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "JDStatusBarNotification.h"
#import "User.h"
typedef void (^Success)(id responseObject);
typedef void (^Failure)(NSError* error);
typedef void (^Handler)(id responseObject,NSError *error);

@interface HttpTool : NSObject
//网络状态
+ (AFNetworkReachabilityStatus)reachability;
//Get json
+ (void)httpGetJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure;
//post data
+ (void)httpPostDataWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure;
+ (void)httpPostDataWithURL:(NSString *)urlString parameters:(NSDictionary *)params handler:(Handler)handler;
//post json
+ (void)httpPostJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure;
+ (void)httpPostJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params handler:(Handler)handler;
//get xml
+ (void)httpGetXmlWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure;
//post xml
+ (void)httpPostXmlWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure;
// 上传文件
+ (void)httpUploadWithURL:(NSString *)urlString path:(NSString *)filePath name:(NSString *)name para:(NSDictionary *)para success:(Success)success failure:(Failure)failure;
// 下载 data
+ (void)httpDataTaskWithURL:(NSString *)urlString  success:(Success)success failure:(Failure)failure;
//下载 image
+ (void)httpDownloadImageWithURL:(NSString *)urlString success:(Success)success failure:(Failure)failure;
//下载 image 并缓存
+ (void)httpCachesImageWithURL:(NSString *)urlString success:(Success)success failure:(Failure)failure;

@end
