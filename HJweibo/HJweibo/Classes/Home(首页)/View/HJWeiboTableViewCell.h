//
//  HJWeiboTableViewCell.h
//  HJweibo
//
//  Created by Jermy on 2017/12/4.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJWeiboModel.h"
#import "HJWeiboLayout.h"

//用户信息View
@interface HJWeiboProfileView : UIView
@property (nonatomic, strong) UIImageView *profileImageView;//头像
@property (nonatomic, strong) YYLabel *screenNameLabel;//用户昵称
@property (nonatomic, strong) YYLabel *sourceLabel;//发布时间、来源
@property (nonatomic, strong) HJWeiboLayout *layout;
@end

//发布的图片
@interface HJWeiboPicView : UIView
@property (nonatomic, strong) HJWeiboLayout *layout;
@property(nonatomic, strong) NSArray *pictureArray;
@end

//转发微博
@interface HJWeiboRetweetView : UIView
@property (nonatomic, strong) YYLabel *textLabel;   //转发文本
@property (nonatomic, strong) HJWeiboPicView *pictureView;  //转发图片
@property (nonatomic, strong) HJWeiboLayout *layout;
@end

//工具栏
@interface HJWeiboToolbarView : UIView
@property (nonatomic, strong) CALayer *topLine;   //顶部分割线
@property (nonatomic, strong) CALayer *bottomLine;   //底部分割线
@property (nonatomic, strong) HJToolBarButton *repostBtn;  //转发按钮
@property (nonatomic, strong) HJToolBarButton *commentBtn; //评论按钮
@property (nonatomic, strong) HJToolBarButton *likeBtn;    //点赞按钮
@property (nonatomic, strong) HJWeiboLayout *layout;
@end

//微博显示界面
@interface HJWeiboStatusView : UIView

@property (nonatomic, strong) HJWeiboLayout *layout;
@property (nonatomic, strong) HJWeiboProfileView *profileView;
@property (nonatomic, strong) YYLabel *textLabel;   //微博文本
@property (nonatomic, strong) HJWeiboPicView *picView;
@property (nonatomic, strong) HJWeiboRetweetView *retweetView;
@property (nonatomic, strong) HJWeiboToolbarView *toolbarView;
@end

@interface HJWeiboTableViewCell : UITableViewCell
@property (nonatomic, strong) HJWeiboLayout *layout;
@property (nonatomic, strong) HJWeiboStatusView *statusView;
@end

@interface HJWeiboImageView : UIViewController
@property (nonatomic, copy)NSString *imageUrl;  //image的地址
@end
