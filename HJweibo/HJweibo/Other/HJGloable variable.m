//
//  HJGloable variable.m
//  HJweibo
//
//  Created by Jermy on 17/3/5.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJGloable variable.h"

//APP版本号
NSString *const appVersionKey = @"CFBundleVersion";


/****************** tableView cell ID  ******************/
//主页顶端搜索按钮的cellID
NSString *const homeViewSearchCellID = @"homeViewSearchCell";
//主页微博消息的cellID
NSString *const homeViewWeiboCellID  = @"HJWeiboCellID";

//图片下载成功的通知
NSString *const HJImageDidDownLoadedNotificaion = @"imageDidDownLoadedNotificaion";

//发布按钮点击的通知
NSString *const HJPublishBtnClickNotification = @"HJPublishBtnClickNotification";

/****************** tableView cell ID  ******************/

/****************** 微博请求地址、秘钥  ******************/
//微博的key 和 秘钥
NSString *const weiboKey = @"402791712";
NSString *const weiboSecret = @"2b0d9fd8bb059ce8df02380f70757b1e";

//微博请求授权地址
NSString *const authUrl = @"https://api.weibo.com/oauth2/authorize";
//微博授权回调地址
NSString *const redirectRri = @"https://api.weibo.com/oauth2/default.html";

//最新公共微博
NSString *const publicTimeline = @"https://api.weibo.com/2/statuses/public_timeline.json";
//获取当前登录用户及其所关注（授权）用户的最新微博
NSString *const friendTimeline = @"https://api.weibo.com/2/statuses/friends_timeline.json";
//获取当前登录用户及其所关注（授权）用户的最新微博
NSString *const homeTimeline = @"https://api.weibo.com/2/statuses/home_timeline.json";

//将一个或多个长链接转换成短链接
NSString *const longUrlToShort = @"https://api.weibo.com/2/short_url/shorten.json";

//将一个或多个短链接还原成原始的长链接
NSString *const shortUrlToLong = @"https://api.weibo.com/2/short_url/expand.json";

//批量获取短链接的富内容信息
NSString *const shortUrlInfo = @"https://api.weibo.com/2/short_url/info.json";

//获取官方表情
NSString *const getEmotions = @"https://api.weibo.com/2/emotions.json";
/****************** 微博请求地址、秘钥  ******************/

/****************** 存储官方表情的数据库  ******************/
//创建表的语句
NSString *const EmotionSQLcreateTable = @"CREATE TABLE IF NOT EXISTS 't_emotions' ('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'value' TEXT,'url' TEXT);";


/****************** 存储官方表情的数据库  ******************/

