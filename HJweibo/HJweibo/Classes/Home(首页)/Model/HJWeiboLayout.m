//
//  HJWeiboLayout.m
//  HJweibo
//
//  Created by Jermy on 2017/12/4.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJWeiboLayout.h"
#import "HJWeiboModel.h"

@implementation HJWeiboLayout

-(instancetype)initWithStatus:(HJStatus *)status
{
    self = [super init];
    _status = status;
    [self _layout];
    return self;
}

-(void)_layout
{
    [self layoutProfile];
}

//计算用户信息
-(void)layoutProfile
{
    HJUserModel *userInfo = _status.user;
    NSString *userName = userInfo.screen_name;
    _screenNameWidth = [self boundingRectsize:userName size:CGSizeMake(ScreenWidth, ProfileNameLabelHeight) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:ScreenNameFontSize]}].width;
    _profileHeight = ProfileImageViewHeight;
}

-(CGSize)boundingRectsize:(NSString *)string size:(CGSize)size attributes:(NSDictionary *)attributes
{
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL].size;
}
@end
