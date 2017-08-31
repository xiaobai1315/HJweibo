//
//  HJGloable variable.h
//  HJweibo
//
//  Created by Jermy on 17/3/5.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <Foundation/Foundation.h>

//APP版本号
UIKIT_EXTERN NSString *const appVersionKey;


/****************** tableView cell ID  ******************/
//首页的搜索框cellID
UIKIT_EXTERN NSString *const homeViewSearchCellID;
//主页微博消息的cellID
UIKIT_EXTERN NSString *const homeViewWeiboCellID;

//图片下载成功的通知
UIKIT_EXTERN NSString *const HJImageDidDownLoadedNotificaion;

//发布按钮点击的通知
UIKIT_EXTERN NSString *const HJPublishBtnClickNotification;
/****************** tableView cell ID  ******************/


/****************** 微博请求地址、秘钥  ******************/
//微博的key 和 秘钥
UIKIT_EXTERN NSString *const weiboKey;
UIKIT_EXTERN NSString *const weiboSecret;
//微博请求授权地址
UIKIT_EXTERN NSString *const authUrl;
//微博授权回调地址
UIKIT_EXTERN NSString *const redirectRri;
//返回最新的公共微博
UIKIT_EXTERN NSString *const publicTimeline;
//获取当前登录用户及其所关注（授权）用户的最新微博
UIKIT_EXTERN NSString *const friendTimeline;
//获取当前登录用户及其所关注（授权）用户的最新微博
UIKIT_EXTERN NSString *const homeTimeline;
//将一个或多个长链接转换成短链接
UIKIT_EXTERN NSString *const longUrlToShort;
//将一个或多个短链接还原成原始的长链接
UIKIT_EXTERN NSString *const shortUrlToLong;
//批量获取短链接的富内容信息
UIKIT_EXTERN NSString *const shortUrlInfo;
//获取官方表情
UIKIT_EXTERN NSString *const getEmotions;

/****************** 微博请求地址、秘钥  ******************/


/****************** 存储官方表情的数据库  ******************/
//创建表的语句
UIKIT_EXTERN NSString *const EmotionSQLcreateTable;




/****************** 存储官方表情的数据库  ******************/

