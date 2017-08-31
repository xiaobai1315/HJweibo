//
//  HJTools.h
//  HJweibo
//
//  Created by Jermy on 2017/6/28.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJTools : NSObject

+(instancetype)shareManager;

//获取微博发布平台
-(NSString *)getPlatformSource:(NSString *)source;

//获取微博发布时间,转换成 刚刚 几分钟前 几个小时前 形式
-(NSString *)getPublishTime:(NSString *)publishTime;

// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL;

//删除文本中的HTTP连接
-(NSString *)deleteHttpStr:(NSString *)text;
@end
