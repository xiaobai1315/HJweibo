//
//  HJUserModel.h
//  HJweibo
//
//  Created by Jermy on 2017/6/26.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJUserModel : NSObject

@property(nonatomic, copy)NSString *screen_name;        //用户昵称
@property(nonatomic, copy)NSString *profile_image_url;  //头像地址
@property(nonatomic, copy)NSString *avatar_large;       //头像大图
@property(nonatomic, copy)NSString *avatar_hd;          //头像高清

@end
