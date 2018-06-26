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
@interface HJWeiboPicView()<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@end

@implementation HJWeiboPicView
{
    BOOL _isPresent;
    NSString *_selImage;
    CGRect _selImageViewFrame;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    for(NSInteger i = 0; i < 9; i++){
        UIImageView *imageView = [UIImageView new];
        imageView.hidden = YES;
        imageView.backgroundColor = [UIColor greenColor];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.tag = i;
        
        //添加点击手势
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidSelcted:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
    }
    return self;
}

-(void)layoutSubviews
{
    CGFloat imageW = ImageViewW;
    CGFloat imageH = ImageViewW;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    NSInteger imagePerRow = 3;  //每一行图片的个数

    if (_pictureArray.count == 1) {
        
        imageW = SingalImageViewW;
        imageH = SingalImageViewH;
    }
    
    if (_pictureArray.count == 4) {
        imagePerRow = 2;
    }
    
    for (NSInteger i = 0; i < self.subviews.count; i++) {

        UIView *view = self.subviews[i];
        if (![view isKindOfClass:[UIImageView class]]) {
            continue;
        }
        
        UIImageView *imageView = (UIImageView *)view;
        
        //没有图片时隐藏imageView 防止复用出现问题
        if ((_pictureArray == nil) || (_pictureArray.count == 0)) {
            imageView.hidden = YES;
            continue;
        }
        
        //图片数量少于9 隐藏没有用到的imageView 防止复用出现问题
        if (i > _pictureArray.count - 1) {
            imageView.hidden = YES;
            continue;
        }
        
        imageView.hidden = NO;
        NSInteger row = i / imagePerRow;
        NSInteger column = i % imagePerRow;
        imageX = (ImageViewW + HJMargin) * column;
        imageY = (ImageViewW + HJMargin) * row;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    }
}

-(void)setPictureArray:(NSArray *)pictureArray
{
    _pictureArray = pictureArray;
    
    for (NSInteger i = 0; i < pictureArray.count; i++) {
        UIView *view = self.subviews[i];
        if (![view isKindOfClass:[UIImageView class]]) {
            continue;
        }
        
        UIImageView *imageView = (UIImageView *)view;
        
        NSString *picture = pictureArray[i];
        if (![picture containsString:@"thumbnail"]) {
            continue;
        }
        picture = [picture stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
                             
        __weak UIImageView *weakImageView = imageView;

        [imageView setImageWithURL:[NSURL URLWithString:picture] placeholder:nil options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {

            //裁剪长图
            if (image.size.height > ScreenHeight) {
                CGFloat imageW = image.size.width;
                CGFloat imageViewW = weakImageView.size.width;
                CGFloat imageViewH = weakImageView.size.height;
                CGFloat imageH = imageW * imageViewH / imageViewW;
                
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), 0, [UIScreen mainScreen].scale);
                [image drawAtPoint:CGPointMake(0, 0)];
                UIImage *_image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();

                weakImageView.image = _image;
            }
        }];
    }
}

-(void)imageDidSelcted:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    
    //保存选中的图片和图片的坐标
    _selImage = _pictureArray[tap.view.tag];
    _selImageViewFrame = [imageView convertRect:imageView.bounds toViewOrWindow:self.window];
    
    NSString *picUrl = _pictureArray[imageView.tag];
    if (picUrl == nil || picUrl.length == 0) {
        return;
    }
    
    if (![picUrl containsString:@"thumbnail"]) {
        return;
    }
    
    picUrl = [picUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    
    HJWeiboImageView *_imageView = [[HJWeiboImageView alloc] init];
    _imageView.imageUrl = picUrl;
    
    _imageView.modalPresentationStyle = UIModalPresentationCustom;
    _imageView.transitioningDelegate = self;
    
    [self.viewController presentViewController:_imageView animated:YES completion:nil];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _isPresent = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _isPresent = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (_isPresent) {
        [self presentTransition:transitionContext];
    }else {
        [self dismissTransition:transitionContext];
    }
}

- (void)presentTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    //获取当前点击的图片
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor blackColor];
    backView.frame = fromVC.view.bounds;
    backView.alpha = 0;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = _selImageViewFrame;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setImageURL:[NSURL URLWithString:_selImage]];
    
    fromVC.view.hidden = YES;
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.hidden = YES;
    
    [transitionContext.containerView addSubview:toVC.view];
    [transitionContext.containerView addSubview:backView];
    [transitionContext.containerView addSubview:imageView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        imageView.frame = backView.bounds;
        backView.alpha = 1;
    } completion:^(BOOL finished) {
        toVC.view.hidden = NO;
        [imageView removeFromSuperview];
        [backView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIView *backView = [[UIView alloc] init];
    backView.frame = fromVC.view.bounds;
    backView.backgroundColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = backView.bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setImageURL:[NSURL URLWithString:_selImage]];
    
    fromVC.view.hidden = YES;
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.hidden = NO;
    toVC.view.alpha = 1;
    
    [transitionContext.containerView addSubview:backView];
    [transitionContext.containerView addSubview:imageView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
       
        backView.alpha = 0;
        imageView.frame = _selImageViewFrame;
        
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}


//- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
//{
//    _isPresent = YES;
//    return self;
//}
//- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator;
//
//- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0);

@end

//转发微博
@implementation HJWeiboRetweetView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _textLabel = [[YYLabel alloc] init];
    [self addSubview:_textLabel];
    
    _pictureView = [[HJWeiboPicView alloc] init];
    [self addSubview:_pictureView];
    
    return self;
}

-(void)setLayout:(HJWeiboLayout *)layout
{
    _layout = layout;
    
    CGFloat width = ScreenWidth - HJMargin * 2;
    
    _textLabel.attributedText = layout.retweetContentText;
    _textLabel.font = RetweetWeiboContentFontSize;
    _textLabel.numberOfLines = 0;
    _textLabel.frame = CGRectMake(HJMargin, HJMargin, width, _layout.retweetTextHeight);
    
    _pictureView.frame = CGRectMake(HJMargin, _textLabel.bottom + HJMargin, width, _layout.retweetPicHeight);
    _pictureView.pictureArray = layout.retweetPicArray;
}

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
    
    //昵称、头像
    _profileView = [HJWeiboProfileView new];
    [self addSubview:_profileView];
    
    //微博文本
    _textLabel = [YYLabel new];
    [self addSubview:_textLabel];
    
    //发布图片
    _picView = [HJWeiboPicView new];
    [self addSubview:_picView];
    
    //转发微博
    _retweetView = [HJWeiboRetweetView new];
    _retweetView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self addSubview:_retweetView];
    
    //工具栏
    _toolbarView = [HJWeiboToolbarView new];
    [self addSubview:_toolbarView];
    
    return self;
}

-(void)setLayout:(HJWeiboLayout *)layout
{
    CGFloat viewW = ScreenWidth - HJMargin * 2;
    _layout = layout;
    
    //用户信息
    _profileView.frame = CGRectMake(HJMargin, HJMargin, viewW, layout.profileHeight);
    _profileView.layout = layout;
    
    //微博文本
    _textLabel.frame = CGRectMake(HJMargin, _profileView.bottom + HJMargin, viewW, layout.textHeight);
    _textLabel.attributedText = layout.contentText;
    _textLabel.numberOfLines = 0;
    _textLabel.font = WeiboContentFontSize;
    
    //转发微博和图片只能同时存在一个
    if (layout.retweetHeight != 0) {    //转发区有内容
        _picView.hidden = YES;
        _retweetView.hidden = NO;
        
        //转发微博
        _retweetView.layout = layout;
        _retweetView.frame = CGRectMake(0, _textLabel.bottom + HJMargin, ScreenWidth, layout.retweetHeight);
        
    }else {
        _picView.hidden = NO;
        _retweetView.hidden = YES;
        
        //图片区
        _picView.pictureArray = layout.picArray;
        _picView.frame = CGRectMake(HJMargin, _textLabel.bottom + HJMargin, viewW, layout.picHeight);
    }
    
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

//点击图片时弹出的大图View
@implementation HJWeiboImageView
{
    UIImageView *_imageView;
}

-(instancetype)init
{
    self = [super init];
    self.view.backgroundColor = [UIColor blackColor];
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = self.view.bounds;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    return self;
}

-(void)setImageUrl:(NSString *)imageUrl
{
    [_imageView setImageURL:[NSURL URLWithString:imageUrl]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
