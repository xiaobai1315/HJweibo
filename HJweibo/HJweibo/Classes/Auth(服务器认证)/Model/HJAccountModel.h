//
//  HJAccountModel.h
//  HJweibo
//
//  Created by Jermy on 2017/6/14.
//  Copyright © 2017年 Jermy. All rights reserved.
//  微博授权信息

#import <Foundation/Foundation.h>

@interface HJAccountModel : NSObject

@property(nonatomic, copy)NSString *access_token;

@property(nonatomic, assign)long long expires_in;

@property(nonatomic, assign)long long remind_in;

@property(nonatomic, assign)long long uid;

@property (nonatomic, assign)BOOL isRealName;

-(instancetype)initAccountWithDict:(NSDictionary *)dict;
+(instancetype)accountWithDict:(NSDictionary *)dict;
@end
