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
    CGFloat imageX = 0;
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
    NSURL *url = [NSURL URLWithString:layout.status.user.avatar_large];
    
    __weak UIImageView *weakImageView = _profileImageView;
    [_profileImageView setImageWithURL:url
                           placeholder:[UIImage imageNamed:@"placeHolder"] options:YYWebImageOptionShowNetworkActivity
                            completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                
                                //将图片处理成圆形图片
                                CGSize size = weakImageView.size;
                                UIImage *circleImage = [[HJTools shareManager] circleImageWithSize:size image:image];
                                weakImageView.image = circleImage;
    }];
    //设置昵称、VIP
    _screenNameLabel.attributedText = layout.nameText;

    //设置来源
    _sourceLabel.attributedText = layout.sourceText;
    
}

//点击用户信息
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
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

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    //顶部分割线
    _topLine = [CALayer new];
    _topLine.backgroundColor = ToolbarLineColor.CGColor;
    [self.layer addSublayer:_topLine];
    
    //底部分割线
    _bottomLine = [CALayer new];
    _bottomLine.backgroundColor = ToolbarLineColor.CGColor;
    [self.layer addSublayer:_bottomLine];

    //转发按钮
    _repostBtn = [HJToolBarButton buttonWithType:UIButtonTypeCustom];
    _repostBtn.exclusiveTouch = YES;
    [_repostBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_repostBtn addTarget:self action:@selector(repostBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_repostBtn];
    
    //评论按钮
    _commentBtn = [HJToolBarButton buttonWithType:UIButtonTypeCustom];
    _commentBtn.exclusiveTouch = YES;
    [_commentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:_commentBtn];
    
    //点赞按钮
    _likeBtn = [HJToolBarButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.exclusiveTouch = YES;
    [_likeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:_likeBtn];
    
    return self;
}

-(void)repostBtnClick
{
    NSLog(@"repostBtnClick");
}
-(void)layoutSubviews
{
    _topLine.frame = CGRectMake(0, 0, self.width, 1);
    _bottomLine.frame = CGRectMake(0, self.height - 1, self.width, 1);
    
    CGFloat btnW = self.width / 3;
    CGFloat btnH = self.height - 2;
    CGFloat btnY = 0;
    CGFloat btnX = 0;

    NSArray *subViews = self.subviews;
    if(subViews.count == 0){
        return;
    }
    
    for(NSInteger i = 0; i < subViews.count; i++){
        UIButton *btn = subViews[i];
        if(![btn isKindOfClass:[UIButton class]]){
            continue;
        }
        
        btnX = btnW * i;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

-(void)setLayout:(HJWeiboLayout *)layout
{
    _layout = layout;
    
    UIImage *repostImage = [[HJTools shareManager] getWeiboImage:@"timeline_icon_retweet"];
    NSString *repostStr = [NSString stringWithFormat:@"%zd", layout.status.reposts_count];
    [_repostBtn setImage:repostImage forState:UIControlStateNormal];
    [_repostBtn setTitle:repostStr forState:UIControlStateNormal];
    
    UIImage *commentImage = [[HJTools shareManager] getWeiboImage:@"timeline_icon_comment"];
    NSString *commentStr = [NSString stringWithFormat:@"%zd", layout.status.comments_count];
    [_commentBtn setImage:commentImage forState:UIControlStateNormal];
    [_commentBtn setTitle:commentStr forState:UIControlStateNormal];
    
    UIImage *likeImage = [[HJTools shareManager] getWeiboImage:@"timeline_icon_unlike"];
    NSString *likeStr = [NSString stringWithFormat:@"%zd", layout.status.attitudes_count];
    [_likeBtn setImage:likeImage forState:UIControlStateNormal];
    [_likeBtn setTitle:likeStr forState:UIControlStateNormal];
}
@end

//微博显示界面
@implementation HJWeiboStatusView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _profileView = [HJWeiboProfileView new];
    [self addSubview:_profileView];
    
    _textLabel = [YYLabel new];
    [self addSubview:_textLabel];
    
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
    CGFloat viewW = ScreenWidth - HJMargin * 2;
    
    //用户信息
    _profileView.frame = CGRectMake(HJMargin, HJMargin, viewW, layout.profileHeight);
    _profileView.layout = layout;
    
    //微博文本
    _textLabel.frame = CGRectMake(HJMargin, _profileView.bottom + HJMargin, viewW, layout.textHeight);
    _textLabel.attributedText = layout.contentText;
    _textLabel.numberOfLines = 0;
    _textLabel.font = WeiboContentFontSize;
    
    //工具栏
    _toolbarView.frame = CGRectMake(HJMargin, layout.cellHeight - ToolBarHeight - 10, ScreenWidth - HJMargin * 2, ToolBarHeight);
    _toolbarView.layout = layout;
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

//重写cell的frame，留出上下的空白
-(void)setFrame:(CGRect)frame
{
    frame.origin.y -= 10;
    frame.size.height -= 10;
    
    [super setFrame:frame];
}

@end
