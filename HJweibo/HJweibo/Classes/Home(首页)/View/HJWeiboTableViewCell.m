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
    UIImageView *profileImageView = [[UIImageView alloc] init];
    _profileImageView = profileImageView;
    [self addSubview:profileImageView];
    
    //VIP图片
    UIImageView *vipImageView = [UIImageView new];
    _vipImageView = vipImageView;
    [self addSubview:vipImageView];
    
    //昵称
    UILabel *profileNameLabel = [UILabel new];
    _profileLabel = profileNameLabel;
    [self addSubview:_profileLabel];
    
    //发布来源
    UILabel *sourceLabel = [UILabel new];
    _sourceLabel = sourceLabel;
    [self addSubview:sourceLabel];
    
    return self;
}

-(void)setLayout:(HJWeiboLayout *)layout
{
    _layout = layout;
    
    
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
    _layout = layout;
    _statusView.layout = layout;
    self.contentView.height = layout.cellHeight;
}
@end
