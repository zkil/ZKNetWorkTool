//
//  HttpTool.h
//  test
//
//  Created by lee on 16/2/1.
//  Copyright © 2016年 sanchun. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^Success)(id responseObject);
typedef void (^Failure)(NSError* error);

@interface ZKHttpTool : NSObject
+(ZKHttpTool *)sharedHttpTool;
@property(nonatomic)AFHTTPSessionManager *jsonManager;

+(AFNetworkReachabilityStatus)reachability;

+(void)httpToolGETWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure;

+(void)httpToolPOSTWithURL:(NSString *)urlString parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure;

+(void)httpToolDataTaskWithURL:(NSString *)urlString  success:(Success)success failure:(Failure)failure;

+(void)httpToolDownImageWithURL:(NSString *)urlString success:(Success)success failure:(Failure)failure;
@end
