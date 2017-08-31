//
//  HJAuthViewController.m
//  HJweibo
//
//  Created by Jermy on 2017/6/13.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJAuthViewController.h"
#import <AFNetworking.h>
#import "HJAccountModel.h"
#import "HJTabBarController.h"

@interface HJAuthViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HJAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //访问授权页
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"https://api.weibo.com/oauth2/authorize?client_id=402791712&redirect_uri=https://api.weibo.com/oauth2/default.html"]];
    [self.webView loadRequest:request];
    
}

#pragma mark WebView代理
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *requestUrl = request.URL.absoluteString;
    
    //获取服务器返回的认证码
    NSRange range = [requestUrl rangeOfString:@"code="];
    
    if(range.length == 0) return YES;
    
    NSString *authCode = [requestUrl substringFromIndex:range.location + range.length];
    
    [self getAccessToken:authCode];
    
    [SVProgressHUD dismiss];
    
    return NO;
}

//获取服务器授权
-(void)getAccessToken:(NSString *)authCode
{
    NSString *accessUrl = @"https://api.weibo.com/oauth2/access_token";
    NSDictionary *para = @{
                           @"client_id" : weiboKey,
                           @"client_secret" : weiboSecret,
                           @"grant_type" : @"authorization_code",
                           @"code" : authCode,
                           @"redirect_uri" : redirectRri
                           };
    
    //发送post请求
    [[AFHTTPSessionManager manager] POST:accessUrl parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //请求成功，保存授权信息
        HJAccountModel *account = [HJAccountModel accountWithDict:responseObject];
        [NSKeyedArchiver archiveRootObject:account toFile:AccountCachePath];
        
        //跳转到首页
        HJTabBarController *tabbarVC = [[HJTabBarController alloc] init];
        [self presentViewController:tabbarVC animated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
