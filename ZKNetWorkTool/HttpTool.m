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

#import "HttpTool.h"

@implementation HttpTool
+ (instancetype)sharedTool {
    static HttpTool *_httpTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _httpTool = [[HttpTool alloc]initWithSessionConfiguration:configuration];
        [_httpTool.requestSerializer setValue:@"UTF-8" forHTTPHeaderField:@"Http-Code"];
        _httpTool.requestSerializer.timeoutInterval = 20;
        _httpTool.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain" ,@"text/html" ,@"text/xml",nil];
        
    });
    return _httpTool;
}

+ (NSURLSessionDataTask *)GET_DATA:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))downloadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *manager = [HttpTool sharedTool];
    [self setupHTTPResponse];
    return [manager GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
}

+ (NSURLSessionDataTask *)GET_JSON:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))downloadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *manager = [HttpTool sharedTool];
    [self setupJSONResponse];
    return [manager GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
}

+ (NSURLSessionDataTask *)POST_DATA:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))uploadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *manager = [HttpTool sharedTool];
    [self setupHTTPResponse];
    return [manager POST:URLString parameters:parameters progress:uploadProgress success:success failure:failure];
}

+ (NSURLSessionDataTask *)POST_JSON:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))uploadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *manager = [HttpTool sharedTool];
    [self setupJSONResponse];
    return [manager POST:URLString parameters:parameters progress:uploadProgress success:success failure:failure];

}

+ (AFHTTPResponseSerializer *)setupHTTPResponse {
    
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain" ,@"text/html" ,@"text/xml",nil];
    
    AFHTTPSessionManager *manager = [HttpTool sharedTool];
    manager.responseSerializer = serializer;
    return serializer;
}

+ (AFHTTPResponseSerializer *)setupJSONResponse {
    AFHTTPResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain" ,@"text/html" ,@"text/xml",nil];
    AFHTTPSessionManager *manager = [HttpTool sharedTool];
    manager.responseSerializer = serializer;
    return serializer;
}

+ (AFHTTPResponseSerializer *)setupIMAGEResponse {
    AFHTTPResponseSerializer *serializer = [AFImageResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain" ,@"text/html" ,@"text/xml",nil];
    AFHTTPSessionManager *manager = [HttpTool sharedTool];
    manager.responseSerializer = serializer;
    return serializer;
}
#pragma -mark- 网络状态
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

#pragma -mark- json
+ (void)httpGetJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure
{
    [self GET_JSON:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure != nil) {
            failure(error);
        }
    }];

//    [[HttpTool sharedTool] GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];

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
}

+ (void)httpGetDataWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure
{
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
+ (void)httpPostDataWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure{
//    [[HttpTool sharedTool] POST:urlString parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];
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
    
//    [[HttpTool sharedTool]POST:urlString parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (handler != nil) {
//            handler(responseObject,nil);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        handler(nil,error);
//    }];
}

+(void)httpPostJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure
{
    [self POST_JSON:urlString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(success != nil) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(failure != nil) {
            failure(error);
        }
    }];
    
//    [[HttpTool sharedTool] POST:urlString parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];

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

//    [[HttpTool sharedTool]POST:urlString parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (handler != nil) {
//            handler(responseObject,nil);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        handler(nil,error);
//    }];
}

+ (void)httpUploadWithURL:(NSString *)urlString path:(NSString *)filePath name:(NSString *)name para:(NSDictionary *)para success:(Success)success failure:(Failure)failure{

    NSString *fileName = [filePath lastPathComponent];
    //@"file";
    
    
    //@"voiceByte";
    
    NSString *miniType = [self getMIMETypeWithCAPIAtFilePath:filePath];
    if (miniType == nil) {
        miniType = @"application/octet-stream";
    }
    
    AFHTTPSessionManager *manager = [HttpTool sharedTool];
    [self setupHTTPResponse];
    
    [manager POST:urlString parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name fileName:fileName mimeType:miniType error:nil];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success != nil) {
            success(responseObject);

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure != nil) {
            failure(error);
        }
        NSLog(@"%@",error.userInfo[NSLocalizedDescriptionKey]);
    }];
    
}

+ (NSString *)getMIMETypeWithCAPIAtFilePath:(NSString *)path
{
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

#pragma -mark-xml
+(void)httpGetXmlWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure{
}
+(void)httpPostXmlWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure{
    
}
#pragma -mark- data
//+(void)httpDataTaskWithURL:(NSString *)urlString  success:(Success)success failure:(Failure)failure
//{
//    
//    NSURL *URL = [NSURL URLWithString:urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURLSessionDataTask *dataTask = [[HttpTool sharedTool] dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//             failure(error);
//        } else {
//            success(responseObject);
//        }
//    }];
//    [dataTask resume];
//    
//}
#pragma -mark- image
+ (void)httpDownloadImageWithURL:(NSString *)urlString success:(Success)success failure:(Failure)failure
{
    AFHTTPSessionManager *manager = [HttpTool sharedTool];
    [self setupIMAGEResponse];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure != nil) {
            failure(error);
        }
    }];
//    [self httpDataTaskWithURL:urlString success:^(id responseObject) {
//        UIImage *img = [[UIImage alloc]initWithData:responseObject];
//        success(img);
//    } failure:^(NSError *error) {
//        failure(error);
//    }];
}

+ (void)httpCachesImageWithURL:(NSString *)urlString success:(Success)success failure:(Failure)failure{
    
    
    AFHTTPSessionManager *manager = [HttpTool sharedTool];
    [self setupIMAGEResponse];
//    
//    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (success != nil) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure != nil) {
//            failure(error);
//        }
//    }];
    //不存在缓存才请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [self setupIMAGEResponse];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            failure(error);
        } else {
            //UIImage *img = [[UIImage alloc]initWithData:responseObject];
            success(responseObject);
        }
    }];
    [dataTask resume];
}
@end































