//
//  NetWorkIndicator.h
//  test
//
//  Created by lee on 16/2/2.
//  Copyright © 2016年 sanchun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZKNetWorkIndicator : NSObject


//+(NetWorkIndicator *)sharedIndicator;

+(void)showIndicator;
+(void)showIndicatorWithStatus:(NSString *)text;

+(void)hiddenIndicator;
@end
