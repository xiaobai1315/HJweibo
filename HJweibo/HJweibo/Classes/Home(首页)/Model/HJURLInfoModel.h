//
//  HJURLInfoModel.h
//  HJweibo
//
//  Created by Jermy on 2017/7/21.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HJURLInfoImageModel;

@interface HJURLInfoModel : NSObject

@property(nonatomic, copy)NSString *display_name;   //显示在微博内容上的连接名

@property(nonatomic, strong)HJURLInfoImageModel *image;

@property(nonatomic, copy)NSString *ext_summary;

@property(nonatomic, copy)NSString *target_url;

@property(nonatomic, copy)NSString *object_type;    //微博类型

@end
