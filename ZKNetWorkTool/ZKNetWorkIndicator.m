//
//  NetWorkIndicator.m
//  test
//
//  Created by lee on 16/2/2.
//  Copyright © 2016年 sanchun. All rights reserved.
//

#import "ZKNetWorkIndicator.h"
#import <UIKit/UIKit.h>

#define kHUDWIDTH 130
#define kHUDHEIGHT 130

#define kSCREENFRAME [UIScreen mainScreen].bounds
#define kSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREENHEIGHT [UIScreen mainScreen].bounds.size.height


@interface ZKNetWorkIndicator()

@property(nonatomic,strong)UIWindow *wiondow;
@property(nonatomic,strong)UIView *HUDView;
@property(nonatomic,strong)UIActivityIndicatorView *indicatorView;
@property(nonatomic,strong)UILabel *statusLable;

@end

@implementation ZKNetWorkIndicator
#pragma -mark- 对外接口
+(void)showIndicator
{
    
    [self sharedIndicator].statusLable.alpha = 0;
    [self sharedIndicator].indicatorView.center = CGPointMake(kSCREENWIDTH/2, kSCREENHEIGHT/2);
    
    [UIView animateWithDuration:0.3 animations:^{
        [self sharedIndicator].HUDView.alpha = 0.4;
        [[self sharedIndicator].indicatorView startAnimating];
    }];
    
   
}
+(void)showIndicatorWithStatus:(NSString *)text
{
   
    
    [self sharedIndicator].indicatorView.center = CGPointMake(kSCREENWIDTH/2, kSCREENHEIGHT/2 - 10);
    [self sharedIndicator].statusLable.text = text;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self sharedIndicator].HUDView.alpha = 0.4;
        [self sharedIndicator].statusLable.alpha = 1;
        [[self sharedIndicator].indicatorView startAnimating];
    }];
    
}
+(void)hiddenIndicator
{
    [UIView animateWithDuration:0.3 animations:^{
        [self sharedIndicator].HUDView.alpha = 0;
        [self sharedIndicator].statusLable.alpha = 0;
        [[self sharedIndicator].indicatorView stopAnimating];
    }];
    
}
#pragma -mark- 对内接口
+(ZKNetWorkIndicator *)sharedIndicator
{
    static ZKNetWorkIndicator *indiicator = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        indiicator = [[self alloc]init];
    });
    return indiicator;
}
-(instancetype)init
{
    if (self = [super init]) {
        [self createSubView];
    }
    return self;
}
-(void)createSubView
{
    _HUDView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kHUDWIDTH , kHUDHEIGHT)];
    _HUDView.center = CGPointMake(kSCREENWIDTH/2, kSCREENHEIGHT/2);
    _HUDView.backgroundColor = [UIColor blackColor];
    _HUDView.alpha = 0;
    _HUDView.layer.cornerRadius = 15.0f;
    //_HUDView.hidden = YES;
    [self.wiondow.rootViewController.view addSubview:_HUDView];
    
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatorView.center = CGPointMake(kSCREENWIDTH/2, kSCREENHEIGHT/2);
    _indicatorView.hidesWhenStopped = YES;
    //_indicatorView.alpha = 0;
    //_indicatorView.hidden = YES;
    [self.wiondow.rootViewController.view addSubview:_indicatorView];
   
    _statusLable = [[UILabel alloc]init];
    _statusLable.frame = CGRectMake(0, 0, kHUDWIDTH - 40, 35);
    _statusLable.center = CGPointMake(kSCREENWIDTH/2, kSCREENHEIGHT/2 + 30);
    _statusLable.textColor = [UIColor whiteColor];
    _statusLable.font = [UIFont systemFontOfSize:16.0f];
    _statusLable.textAlignment = NSTextAlignmentCenter;
    _statusLable.alpha = 0;
    //_statusLable.hidden = YES;
    [self.wiondow.rootViewController.view addSubview:_statusLable];
}
-(UIWindow *)wiondow
{
    if (_wiondow == nil) {
        _wiondow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, kHUDWIDTH, kHUDHEIGHT)];
        //_wiondow.center = CGPointMake(kSCREENWIDTH/2, kSCREENHEIGHT/2);
        UIViewController *rootVC = [[UIViewController alloc]init];
        _wiondow.rootViewController = rootVC;
        _wiondow.windowLevel = UIWindowLevelAlert;
        //rootVC.view.backgroundColor = [UIColor yellowColor];
        [_wiondow makeKeyAndVisible];
    }
    return _wiondow;
}
//-(UIView *)HUDView
//{
//    if (_HUDView == nil) {
//        _HUDView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kHUDWIDTH , kHUDHEIGHT)];
//        _HUDView.backgroundColor = [UIColor blackColor];
//        _HUDView.alpha = 0.5;
//        _HUDView.layer.cornerRadius = 15.0f;
//        [self.wiondow.rootViewController.view addSubview:_HUDView];
//    }
//    _HUDView.center = CGPointMake(kSCREENWIDTH/2, kSCREENHEIGHT/2);
//    return _HUDView;
//}
//-(UIActivityIndicatorView *)indicatorView
//{
//    if (_indicatorView == nil) {
//        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        _indicatorView.center = CGPointMake(kSCREENWIDTH/2, kSCREENHEIGHT/2);
//        _indicatorView.hidesWhenStopped = YES;
//        [self.wiondow.rootViewController.view addSubview:_indicatorView];
//    }
//    [_indicatorView startAnimating];
//     _indicatorView.center = CGPointMake(kSCREENWIDTH/2, kSCREENHEIGHT/2);
//    return _indicatorView;
//}
//-(UILabel *)statusLable
//{
//    if (_statusLable == nil) {
//        _statusLable = [[UILabel alloc]init];
//        _statusLable.adjustsFontSizeToFitWidth = YES;
//        _statusLable.frame = CGRectMake(0, 0, kHUDWIDTH - 40, 35);
//        _statusLable.center = CGPointMake(kSCREENWIDTH/2, kSCREENHEIGHT/2 + 30);
//        _statusLable.textColor = [UIColor whiteColor];
//        _statusLable.font = [UIFont systemFontOfSize:17.0f];
//        _statusLable.textAlignment = NSTextAlignmentCenter;
//        [self.wiondow.rootViewController.view addSubview:_statusLable];
//    }
//    return _statusLable;
//}

@end
