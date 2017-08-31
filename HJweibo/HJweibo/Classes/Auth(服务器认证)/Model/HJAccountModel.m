//
//  HJAccountModel.m
//  HJweibo
//
//  Created by Jermy on 2017/6/14.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJAccountModel.h"

@interface HJAccountModel()<NSCoding>

@end

@implementation HJAccountModel

-(instancetype)initAccountWithDict:(NSDictionary *)dict
{
    if(self = [super init]){
        
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}
+(instancetype)accountWithDict:(NSDictionary *)dict
{
    return [[self alloc] initAccountWithDict:dict];
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeInt64:self.expires_in forKey:@"expires_in"];
    [aCoder encodeInt64:self.remind_in forKey:@"remind_in"];
    [aCoder encodeInt64:self.uid forKey:@"uid"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
        
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.expires_in = [aDecoder decodeInt64ForKey:@"expires_in"];
        self.remind_in = [aDecoder decodeInt64ForKey:@"remind_in"];
        self.uid = [aDecoder decodeInt64ForKey:@"uid"];
    }
    
    return self;
}



@end
