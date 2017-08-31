//
//  HJGetImageSize.m
//  HJweibo
//
//  Created by Jermy on 2017/7/13.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJGetImageSize.h"

typedef void(^success)(NSData *);

@interface HJGetImageSize()<NSURLConnectionDataDelegate>

@property(nonatomic, copy) success successBlock;

@end

@implementation HJGetImageSize

-(void)HJGetImageSizeWithUrl:(NSString *)imageUrl success:(void(^)(NSData *)) success
{
    
    [self sendRequestWithUrl:imageUrl];

    self.successBlock = success;
    
}

//发送请求
-(void)sendRequestWithUrl:(NSString *)imageUrl
{
//    00A3-00A6：00 18 00 20（图像高＝24，图像宽＝32）
    
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"bytes=163-166" forHTTPHeaderField:@"Range"];
    
    [[NSURLConnection connectionWithRequest:request delegate:self] start];
}

//接收到数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    _successBlock(data);
}

@end
