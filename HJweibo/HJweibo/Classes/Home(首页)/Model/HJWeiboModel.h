//
//  HJWeiboModel.h
//  HJweibo
//
//  Created by Jermy on 2017/12/1.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <Foundation/Foundation.h>

//微博文本中需要替换的URL、emoji、用户名等链接信息
@interface HJLinkModel : NSObject
@property (nonatomic, copy) NSString *linkText; //链接的文本
@property (nonatomic, assign) NSRange linkRange;    //链接所在的文本中的位置

+(instancetype)linkModelWithText:(NSString *)text range:(NSRange)range;
@end

/**
 用户信息模型
 */
@interface HJUserModel : NSObject
@property(nonatomic, copy)NSString *screen_name;        //用户昵称
@property(nonatomic, copy)NSString *profile_image_url;  //头像地址
@property(nonatomic, copy)NSString *avatar_large;       //头像大图
@property(nonatomic, copy)NSString *avatar_hd;          //头像高清
@end


@interface HJURLInfoImageModel : NSObject
@property(nonatomic, assign)NSInteger height;
@property(nonatomic, assign)NSInteger width;
@property(nonatomic, copy)NSString *url;
@end


/**
 
*/
@interface HJURLInfoModel : NSObject
@property(nonatomic, copy)NSString *display_name;   //显示在微博内容上的连接名
@property(nonatomic, strong)HJURLInfoImageModel *image;
@property(nonatomic, copy)NSString *ext_summary;
@property(nonatomic, copy)NSString *target_url;
@property(nonatomic, copy)NSString *object_type;    //微博类型
@end

/**
 微博信息模型
*/
@interface HJStatus : NSObject
@property (nonatomic, copy) NSString *created_at;         //创建时间
@property (nonatomic, copy) NSArray *pic_urls;            //图片地址数组
@property (nonatomic, copy) NSString *source;             //发布微博客户端信息
@property (nonatomic, assign) BOOL source_allowclick;     //发布客户端是否允许点击
@property (nonatomic, copy) NSString *text;               //发布的微博内容
@property (nonatomic, copy) NSString *thumbnail_pic;      //缩略图地址
@property (nonatomic, strong) HJUserModel *user;          //用户信息
@property (nonatomic, strong) HJStatus *retweeted_status; //转发的微博信息
@property (nonatomic, assign) NSInteger attitudes_count;  //喜欢的个数
@property (nonatomic, assign) NSInteger comments_count;   //评论的个数
@property (nonatomic, assign) NSInteger reposts_count;    //转帖的个数
@property (nonatomic, assign) NSInteger page_type;        //页面类型 41:web 33:audio 32:text
@property (nonatomic, strong) HJURLInfoModel *urlInfomodel;      //微博链接内容
@property (nonatomic, copy) NSString *longUrl;            //长连接，视频、网页的原连接地址
@property (nonatomic, assign) NSInteger type;             //链接类型，0:普通网页 36:音乐 39:视频
@property (nonatomic, assign) CGFloat cellHeight;         //返回cell的高度
@property (nonatomic, assign) CGRect graphicsViewFrame;   //返回graphicsView的frame
@property (nonatomic, assign) CGRect retweetGraphicsViewFrame;   //返回转发微博的graphicsView的frame
@property (nonatomic, assign) CGRect retweetViewFrame;      //返回转发微博的frame
@property (nonatomic, assign) CGRect webPageFrame;      //返回微博链接的frame
@property (nonatomic, assign) CGRect retweetWebPageFrame;      //返回转发微博链接的frame
@end
