//
//  HJGetImageSize.h
//  HJweibo
//
//  Created by Jermy on 2017/7/13.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJGetImageSize : NSObject

-(void)HJGetImageSizeWithUrl:(NSString *)imageUrl success:(void(^)(NSData *)) success;

@end
