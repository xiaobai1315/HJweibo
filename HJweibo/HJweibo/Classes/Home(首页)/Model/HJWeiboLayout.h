//
//  HJWeiboLayout.h
//  HJweibo
//
//  Created by Jermy on 2017/12/4.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HJWeiboModel;

@interface HJWeiboLayout : NSObject
-(instancetype)initWithStatus:(HJStatus *)status;

//布局结果
//顶部留白
@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, strong) HJStatus *status;

//用户信息:头像、名字、VIP、发布时间、发布来源
@property (nonatomic, assign) CGFloat profileHeight; //用户信息View的高度
@property (nonatomic, strong) NSMutableAttributedString *nameText;
@property (nonatomic, strong) NSMutableAttributedString *sourceText;

//发布文本
@property (nonatomic, assign) CGFloat textHeight;   //文本高度
@property (nonatomic, strong) NSMutableAttributedString *contentText;//文本内容

//图片
@property (nonatomic, assign) CGFloat picHeight;

//转发微博
@property (nonatomic, assign) CGFloat retweetHeight;

//工具栏
@property (nonatomic, assign) CGFloat toolBarHeight;

//总高度
@property (nonatomic, assign) CGFloat cellHeight;
@end
