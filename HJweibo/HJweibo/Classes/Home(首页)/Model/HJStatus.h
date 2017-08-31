//
//  HJStatus.h
//  HJweibo
//
//  Created by Jermy on 2017/6/26.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJUserModel.h"

@interface HJStatus : NSObject

@property(nonatomic, copy)NSString *created_at;         //创建时间
@property(nonatomic, copy)NSArray *pic_urls;            //图片地址数组
@property(nonatomic, copy)NSString *source;             //发布微博客户端信息
@property(nonatomic, assign)BOOL source_allowclick;     //发布客户端是否允许点击
@property(nonatomic, copy)NSString *text;               //发布的微博内容
@property(nonatomic, copy)NSString *thumbnail_pic;      //缩略图地址
@property(nonatomic, strong)HJUserModel *user;          //用户信息
@property(nonatomic, strong)HJStatus *retweeted_status; //转发的微博信息
@property(nonatomic, assign)NSInteger attitudes_count;  //喜欢的个数
@property(nonatomic, assign)NSInteger comments_count;   //评论的个数
@property(nonatomic, assign)NSInteger reposts_count;    //转帖的个数
@property(nonatomic, assign)NSInteger page_type;        //页面类型 41:web 33:audio 32:text
@property(nonatomic, strong)HJURLInfoModel *urlInfomodel;      //微博链接内容

@property(nonatomic, copy)NSString *longUrl;            //长连接，视频、网页的原连接地址
@property(nonatomic, assign)NSInteger type;             //链接类型，0:普通网页 36:音乐 39:视频

@property(nonatomic, assign)CGFloat cellHeight;         //返回cell的高度
@property(nonatomic, assign)CGRect graphicsViewFrame;   //返回graphicsView的frame
@property(nonatomic, assign)CGRect retweetGraphicsViewFrame;   //返回转发微博的graphicsView的frame
@property(nonatomic, assign)CGRect retweetViewFrame;      //返回转发微博的frame

@property(nonatomic, assign)CGRect webPageFrame;      //返回微博链接的frame
@property(nonatomic, assign)CGRect retweetWebPageFrame;      //返回转发微博链接的frame
@end
