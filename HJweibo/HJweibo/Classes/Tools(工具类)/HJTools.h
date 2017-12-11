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

//获取微博发布时间,转换成 刚刚 几分钟前 几个小时前 形式
-(NSString *)getPublishTime:(NSString *)publishTime;

//采用C的函数转换时间，效率比NSDateFormat快
-(NSString *)convertTime:(NSString *)publishTime;

// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL;

//获取微博bundle里面的图片
-(UIImage *)getWeiboImage:(NSString *)imageName;

//根据正则表达式获取字符串
-(NSArray *)regularExpressionWithString:(NSString *)string pattern:(NSString *)pattern;

//处理圆形图片
-(UIImage *)circleImageWithSize:(CGSize)size image:(UIImage *)image;

//获取微博授权秘钥
-(NSString *)getAccessToken;
@end
