//
//  HJNetRequest.m
//  HJweibo
//
//  Created by Jermy on 2017/12/11.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJNetRequest.h"
#import <AFNetworking.h>

@implementation HJNetRequest

static HJNetRequest *_instance;

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

-(id)copy
{
    return _instance;
}

#pragma mark function

- (NSURLSessionDataTask *)get:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    
    return [manager GET:URLString parameters:parameters success:success failure:failure];
}


@end
