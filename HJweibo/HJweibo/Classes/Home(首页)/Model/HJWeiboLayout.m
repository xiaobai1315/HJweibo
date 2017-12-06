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
    _profileHeight = 0;
    
    [self layoutProfile];
    
    _cellHeight = 200;
}

//计算用户信息
-(void)layoutProfile
{
    _profileHeight = 40;
    
    /**
     * 昵称+vip
     */
    HJUserModel *userModel = _status.user;
    NSString *nameStr = userModel.screen_name;
    if(nameStr.length == 0){
        _nameText = nil;
    }
    
    _nameText = [[NSMutableAttributedString alloc] initWithString:nameStr];
    [_nameText appendString:@" "];
    UIImage *vipImage = [[HJTools shareManager] getWeiboImage:@"avatar_vip"];
    vipImage = [UIImage imageWithCGImage:vipImage.CGImage scale:2 orientation:UIImageOrientationUp];
    NSMutableAttributedString *imageStr = [NSMutableAttributedString attachmentStringWithContent:vipImage contentMode:UIViewContentModeCenter attachmentSize:vipImage.size alignToFont:ScreenNameFontSize alignment:YYTextVerticalAlignmentCenter];
    
    [_nameText appendAttributedString:imageStr];
    _nameText.font = ScreenNameFontSize;
    _nameText.color = ScreenNameFontColor;
    
    /**
     * 发布时间及来源
     */
    if((_status.source.length == 0) && (_status.created_at.length == 0)){
        _sourceText = nil;
    }
    
    //发布时间
    NSString *time = [[HJTools shareManager] getPublishTime:_status.created_at];
    time = [time stringByAppendingString:@" "];
    _sourceText = [[NSMutableAttributedString alloc] initWithString:time];
    _sourceText.color = SourceFontColor;
    _sourceText.font = SourceFontSize;
    
    //发布来源
    NSString *source = _status.source;
    NSString *sourceUrl = [[HJTools shareManager] regularExpressionWithString:source pattern:SourceUrlPattern];
    NSString *sourceClient = [[HJTools shareManager] regularExpressionWithString:source pattern:SourceClientPattern];
    
    //如果来源客户端长度为0，只返回时间
    if(sourceClient.length == 0){
        return;
    }
    
    sourceClient = [@"来自" stringByAppendingString:sourceClient];
    [_sourceText appendString:sourceClient];
    
    //需要高亮的部分
    NSRange highlightRange = NSMakeRange(time.length + 2, sourceClient.length - 2);
    
    //客户端允许点击
    if(_status.source_allowclick){
        [_sourceText setColor:SourceAllowClickFontColor range:highlightRange];
        
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setColor:SourceHighlightFontColor];
        [highlight setTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"%@", sourceUrl);
        }];
        
        [_sourceText setTextHighlight:highlight range:highlightRange];
    }
}

-(CGSize)boundingRectsize:(NSString *)string size:(CGSize)size attributes:(NSDictionary *)attributes
{
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL].size;
}
@end
