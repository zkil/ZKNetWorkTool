# ZKNetWorkTool
简介：  
基于AFNetworking的封装  

### 导入
`#import "ZKHttpTool.h"`

### 开始获取和监听网络状态并监听网络状态
`+ (AFNetworkReachabilityStatus)reachability;`  
通过监听通知AFNetworkingReachabilityDidChangeNotification对网络状态监听

### 网络请求
```
/**
 get json

 @param urlString url
 @param params    传的参数
 @param handler   回调
 */

+ (void)httpGetJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params handler:(Handler)handler;
```

```
/**
 get data
 
 @param urlString url
 @param params    传的参数
 @param handler   回调
 */
+ (void)httpGetDataWithURL:(NSString *)urlString parameters:(NSDictionary *)params handler:(Handler)handler;
```

```
 post data
 
 @param urlString url
 @param params    传的参数
 @param handler   回调
 */
+ (void)httpPostDataWithURL:(NSString *)urlString parameters:(NSDictionary *)params handler:(Handler)handler;
```

```
/**
 post json
 
 @param urlString url
 @param params    传的参数
 @param handler   回调
 */
+ (void)httpPostJsonWithURL:(NSString *)urlString parameters:(NSDictionary *)params handler:(Handler)handler;
```

