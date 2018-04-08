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
@property (nonatomic, strong) NSArray *picArray;


//转发微博
@property (nonatomic, assign) CGFloat retweetHeight;
@property (nonatomic, assign) CGFloat retweetTextHeight;   //转发文本高度
@property (nonatomic, strong) NSMutableAttributedString *retweetContentText;//转发文本内容
@property (nonatomic, assign) CGFloat retweetPicHeight; //转发图片高度
@property (nonatomic, strong) NSArray *retweetPicArray; //转发图片数组

//工具栏
@property (nonatomic, assign) CGFloat toolBarHeight;

//总高度
@property (nonatomic, assign) CGFloat cellHeight;
@end
