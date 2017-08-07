//
//  ZKHttpTool.m
//  ZKNetWorkTool
//
//  Created by pang on 2017/8/7.
//  Copyright © 2017年 sanchun. All rights reserved.
//

#import "ZKHttpTool.h"

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@implementation ZKHttpTool

+ (instancetype)manager {
    ZKHttpTool *httpTool = [super manager];
    //自定义
    
    //SSL
    httpTool.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    httpTool.securityPolicy.allowInvalidCertificates = YES;
    [httpTool.securityPolicy setValidatesDomainName:NO];
    
    //请求头
    //[httpTool.requestSerializer setValue:@"UTF-8" forHTTPHeaderField:@"Http-Code"];
    //超时时间
    //httpTool.requestSerializer.timeoutInterval = 30;
    httpTool.responseSerializer = [AFHTTPResponseSerializer serializer];
    httpTool.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain" ,@"text/html" ,@"text/xml",nil];
    
    return httpTool;
}


+ (NSURLSessionDataTask *)GET_DATA:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))downloadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *manager = [self manager];
    
    return [manager GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
}

+ (NSURLSessionDataTask *)GET_JSON:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))downloadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *manager = [self manager];
    NSURLSessionDataTask *dataTask =  [manager GET:URLString parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain" ,@"text/html" ,@"text/xml",nil];
        NSError *serializationError = nil;
        id  jsonObject = [serializer responseObjectForResponse:task.response data:responseObject error:&serializationError];
        if (serializationError == nil) {
            success(task,jsonObject);
        }else {
            failure(dataTask,serializationError);
        }
        
    } failure:failure];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)POST_DATA:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))uploadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *manager = [self manager];
    return [manager POST:URLString parameters:parameters progress:uploadProgress success:success failure:failure];
}

+ (NSURLSessionDataTask *)POST_JSON:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))uploadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *manager = [self manager];
    NSURLSessionDataTask *dataTask =  [manager POST:URLString parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain" ,@"text/html" ,@"text/xml",nil];
        NSError *serializationError = nil;
        id  jsonObject = [serializer responseObjectForResponse:task.response data:responseObject error:&serializationError];
        if (serializationError == nil) {
            success(task,jsonObject);
        }else {
            failure(dataTask,serializationError);
        }
        
    } failure:failure];
    
    return dataTask;
}


#pragma -mark- 网络状态
+ (AFNetworkReachabilityStatus)reachability {
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"未识别的网络");
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"不可达的网络(未连接)");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"2G,3G,4G...的网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
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

#pragma -mark- json
+ (void)httpGetJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure {
    [self GET_JSON:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure != nil) {
            failure(error);
        }
    }];
    
    
}

+ (void)httpGetJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params handler:(Handler)handler {
    
    [self GET_JSON:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (handler != nil) {
            handler(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (handler != nil) {
            handler(nil, error);
        }
    }];
}


+ (void)httpGetDataWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure {
    [self GET_DATA:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure != nil) {
            failure(error);
        }
    }];
}

+ (void)httpGetDataWithURL:(NSString *)urlString parameters:(NSDictionary *)params handler:(Handler)handler {
    [self GET_DATA:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (handler != nil) {
            handler(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (handler != nil) {
            handler(nil, error);
        }
    }];
}

+ (void)httpPostDataWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure {
    [self POST_DATA:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(success != nil) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(failure != nil) {
            failure(error);
        }
    }];
}

+ (void)httpPostDataWithURL:(NSString *)urlString parameters:(NSDictionary *)params handler:(Handler)handler {
    [self POST_DATA:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (handler != nil) {
            handler(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (handler != nil) {
            handler(nil,error);
        }
    }];
    
}

+(void)httpPostJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure {
    [self POST_JSON:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(success != nil) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(failure != nil) {
            failure(error);
        }
    }];
    
}

+ (void)httpPostJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params handler:(Handler)handler {
    [self POST_JSON:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (handler != nil) {
            handler(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (handler != nil) {
            handler(nil,error);
        }
    }];
    
}


+ (NSString *)getMIMETypeWithCAPIAtFilePath:(NSString *)path {
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    NSString *type = (__bridge NSString *)(MIMEType);
    CFRelease(MIMEType);
    if (type == nil) {
        type = @"application/octet-stream";
    }
    return type;
}


@end
