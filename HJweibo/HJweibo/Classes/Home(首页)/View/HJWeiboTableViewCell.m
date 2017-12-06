//
//  HJWeiboTableViewCell.m
//  HJweibo
//
//  Created by Jermy on 2017/12/4.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJWeiboTableViewCell.h"

//用户信息
@implementation HJWeiboProfileView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    //用户头像
    _profileImageView = [[UIImageView alloc] init];
    [self addSubview:_profileImageView];
    
    //昵称
    _screenNameLabel = [YYLabel new];
    [self addSubview:_screenNameLabel];

    //发布来源
    _sourceLabel = [YYLabel new];
    [self addSubview:_sourceLabel];
    
    return self;
}

-(void)layoutSubviews
{
    //用户头像
    CGFloat imageX = HJMargin;
    CGFloat imageY = 0;
    CGFloat imageW = ProfileImageViewHeight;
    CGFloat imageH = ProfileImageViewHeight;
    _profileImageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    //昵称
    CGFloat screenNameX = imageX + ProfileImageViewHeight + HJMargin;
    CGFloat screenNameY = 0;
    CGFloat screenNameW = ProfileNameLabelWidth;
    CGFloat screenNameH = ProfileNameLabelHeight;
    _screenNameLabel.frame = CGRectMake(screenNameX, screenNameY, screenNameW, screenNameH);
    
    //来源
    CGFloat sourceX = screenNameX;
    CGFloat sourceY = ProfileImageViewHeight * 0.5;
    CGFloat sourceW = ProfileSourceLabelWidth;
    CGFloat sourceH = ProfileSourceLabelHeight;
    _sourceLabel.frame = CGRectMake(sourceX, sourceY, sourceW, sourceH);
}

-(void)setLayout:(HJWeiboLayout *)layout
{
    _layout = layout;
    
    //设置头像
    [_profileImageView setImageURL:[NSURL URLWithString:layout.status.user.profile_image_url]];
    
    //设置昵称、VIP
    _screenNameLabel.attributedText = layout.nameText;

    //设置来源
    _sourceLabel.attributedText = layout.sourceText;
    
}

@end

//发布的图片
@implementation HJWeiboPicView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    for(NSInteger i = 0; i < 9; i++){
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
    }
    return self;
}

@end


//转发微博
@implementation HJWeiboRetweetView

@end

//工具栏
@implementation HJWeiboToolbarView

@end

//微博显示界面
@implementation HJWeiboStatusView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _profileView = [HJWeiboProfileView new];
    [self addSubview:_profileView];
    
    _picView = [HJWeiboPicView new];
    [self addSubview:_picView];
    
    _retweetView = [HJWeiboRetweetView new];
    [self addSubview:_retweetView];
    
    _toolbarView = [HJWeiboToolbarView new];
    [self addSubview:_toolbarView];
    
    return self;
}

-(void)setLayout:(HJWeiboLayout *)layout
{
    _profileView.frame = CGRectMake(0, HJMargin, ScreenWidth, layout.profileHeight);
    _profileView.layout = layout;
}

@end

@implementation HJWeiboTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _statusView = [HJWeiboStatusView new];
    [self.contentView addSubview:_statusView];
    return self;
}

-(void)setLayout:(HJWeiboLayout *)layout
{
    self.height = layout.cellHeight;
    _layout = layout;
    _statusView.layout = layout;
    _statusView.frame = CGRectMake(0, 0, ScreenWidth, layout.cellHeight);
    self.contentView.height = layout.cellHeight;
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.y -= 10;
    frame.size.height -= 10;
    
    [super setFrame:frame];
}

@end
