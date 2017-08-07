

#import <AFNetworking/AFNetworking.h>

typedef void (^Success)(id responseObject);
typedef void (^Failure)(NSError* error);
typedef void (^Handler)(id responseObject,NSError *error);

@interface ZKHttpTool : AFHTTPSessionManager

+ (NSURLSessionDataTask *)GET_JSON:(NSString *)URLString
                        parameters:(id)parameters
                          progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (NSURLSessionDataTask *)GET_DATA:(NSString *)URLString
                        parameters:(id)parameters
                          progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (NSURLSessionDataTask *)POST_JSON:(NSString *)URLString
                         parameters:(id)parameters
                           progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (NSURLSessionDataTask *)POST_DATA:(NSString *)URLString
                         parameters:(id)parameters
                           progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//网络状态
+ (AFNetworkReachabilityStatus)reachability;


+ (void)httpGetJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure;

/**
 get json

 @param urlString url
 @param params    传的参数
 @param handler   回调
 */

+ (void)httpGetJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params handler:(Handler)handler;

+ (void)httpGetDataWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure;

/**
 get data
 
 @param urlString url
 @param params    传的参数
 @param handler   回调
 */
+ (void)httpGetDataWithURL:(NSString *)urlString parameters:(NSDictionary *)params handler:(Handler)handler;

//post data
+ (void)httpPostDataWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure;

/**
 post data
 
 @param urlString url
 @param params    传的参数
 @param handler   回调
 */
+ (void)httpPostDataWithURL:(NSString *)urlString parameters:(NSDictionary *)params handler:(Handler)handler;
//post json
+ (void)httpPostJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure;

/**
 post json
 
 @param urlString url
 @param params    传的参数
 @param handler   回调
 */
+ (void)httpPostJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params handler:(Handler)handler;

+ (NSString *)getMIMETypeWithCAPIAtFilePath:(NSString *)path;

@end
