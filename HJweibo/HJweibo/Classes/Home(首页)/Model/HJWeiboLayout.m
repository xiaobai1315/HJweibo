//
//  HJWeiboLayout.m
//  HJweibo
//
//  Created by Jermy on 2017/12/4.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJWeiboLayout.h"
#import "HJWeiboModel.h"
#import "HJNetRequest.h"

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
    _cellHeight = 0;
    
    [self layoutProfile];
    [self layoutText];
    [self layoutToolBar];
    
    _cellHeight += HJMargin + _profileHeight + HJMargin;
    _cellHeight += _textHeight + HJMargin;
    _cellHeight += _toolBarHeight;
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
    NSString *sourceUrl = @"";
    
    //客户端的链接地址
    NSArray *sourceUrlArr = [[HJTools shareManager] regularExpressionWithString:source pattern:WBUrlPattern];
    if(sourceUrlArr.count != 0){
        sourceUrl = sourceUrlArr[0];
    }
    
    //客户端名字
    NSArray *sourceClientArr = [[HJTools shareManager] regularExpressionWithString:source pattern:SourceClientPattern];
    if(sourceClientArr.count == 0){
        return;
    }
    
    HJLinkModel *linkModel = sourceClientArr[0];
    //截取客户端的字符串
    NSString *sourceClient = linkModel.linkText;
    if(sourceClient.length == 0){
        return;
    }
    
    sourceClient = [sourceClient substringWithRange:NSMakeRange(1, (sourceClient.length - 2))];
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

//微博文本
/*
 @用户： 翻翻她的微博 你会爱上她@住7楼的天屎姐姐。
 emoji表情：一分钟学会韩式蛋卷[馋嘴]
 链接：不是所有人都有湿气，只有出现了这些信号才是湿邪入体，别盲目去湿[可怜][吃惊]http://t.cn/RjihFco
 
 需要做的工作：
 1、短连接 ：获取文本中的短连接(http:// 开头)，请求服务器获取短连接的信息。一个文本中短连接可能有多个。
 短连接为音乐、视频、网页，需要在连接名字前拼接一个表示连接类型的小图片；音乐、视频、网页是否需要添加缩略图？
 2、@用户： 以“@”开头的是@某一个用户，通过@后面的文本字段，请求服务获取用户昵称以及用户主页的连接地址；
 3、[表情]：[]中的内容为emoji表情，需要转换成对应的表情图片；
 
 */
-(void)layoutText
{
    NSString *text = _status.text;
    
    //获取文本中的短连接
    NSArray *shortUrlArr = [[HJTools shareManager] regularExpressionWithString:text pattern:WBUrlPattern];
//    NSLog(@"shortUrlArr = %@", shortUrlArr);
    if(shortUrlArr.count != 0){
        HJLinkModel *model = shortUrlArr[0];
        NSString *link = model.linkText;
        NSLog(@"text = %@", text);
        NSLog(@"link = %@", link);
        //获取短连接的信息
        NSDictionary *para = @{
                               @"access_token" : [[HJTools shareManager] getAccessToken],
                               @"url_short" : link
                               };
        [[HJNetRequest shareInstance] get:shortUrlInfo parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@", responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
    //获取文本中的emoji表情
    NSArray *emojiArr = [[HJTools shareManager] regularExpressionWithString:text pattern:WBContentEmoji];
//    NSLog(@"emojiArr = %@", emojiArr);
    //获取文本中的@用户
    NSArray *atUserArr = [[HJTools shareManager] regularExpressionWithString:text pattern:WBContentAtUser];
//    NSLog(@"atUserArr = %@", atUserArr);
    
    _contentText = [[NSMutableAttributedString alloc] initWithString:text];
    _textHeight = [self boundingRectsize:text size:CGSizeMake(ScreenWidth - 20, MAXFLOAT) attributes:@{NSFontAttributeName: WeiboContentFontSize}].height;
    
}

-(void) layoutToolBar
{
    _toolBarHeight = ToolBarHeight;
}


-(CGSize)boundingRectsize:(NSString *)string size:(CGSize)size attributes:(NSDictionary *)attributes
{
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL].size;
}
@end
