//
//  HJNetRequest.h
//  HJweibo
//
//  Created by Jermy on 2017/12/11.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJNetRequest : NSObject

+ (instancetype)shareInstance;

- (NSURLSessionDataTask *)get:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
