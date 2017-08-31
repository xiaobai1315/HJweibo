//
//  HJVisualEffectView.m
//  HJweibo
//
//  Created by Jermy on 2017/6/12.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJVisualEffectView.h"
#import "HJButton.h"

#define SCROLLVIEWHEIGHT 220    //SCROLLVIEW的高度

@interface HJVisualEffectView()<UIScrollViewDelegate>

@property(nonatomic, weak) UILabel *dayLabel;   //几号label
@property(nonatomic, weak) UILabel *dateLabel;   //日期label
@property(nonatomic, weak) UILabel *weekLabel;   //星期label
@property(nonatomic, weak) UILabel *weatherLabel;//天气label
@property(nonatomic, weak) UIImageView *adverImageView;   //广告imageView
@property(nonatomic, weak) UIImageView *arrowImageView;   //箭头imageView

@property(nonatomic, weak)  UIButton *closeBtn; //关闭按钮
@property(nonatomic, strong) UIScrollView *scrollView;   //功能按钮的父控件
@property(nonatomic, strong) UIPageControl *pageControl; //页码

@property(nonatomic, copy) NSArray *titleArr;    //存储功能按钮的标题
@property(nonatomic, copy) NSArray *imageArr;    //存储按钮的图片
@property(nonatomic, copy) NSMutableArray *viewArr;  //功能按钮容器的数组
@property(nonatomic, copy) NSMutableArray *btnArr;  //存储所有功能按钮
@property(nonatomic, strong)NSTimer *timer;         //控制按钮显示的定时器
@end

@implementation HJVisualEffectView
{
    NSInteger _btnIndex;
}

#pragma mark 懒加载
-(NSArray *)titleArr
{
    if(_titleArr == nil){
        
        _titleArr = @[@"文字", @"好友圈", @"话题", @"直播", @"位置", @"秒拍", @"电影" , @"音乐" , @"相册" , @"购物" , @"展示" , @"头条" , @"视频"];
    }
    
    return _titleArr;
}

-(NSArray *)imageArr
{
    if(_imageArr == nil){
        
        _imageArr = @[@"tabbar_compose_comment_neo", @"tabbar_compose_friends_neo", @"tabbar_compose_idea_neo", @"tabbar_compose_live_neo", @"tabbar_compose_location_neo", @"tabbar_compose_miaopai_neo", @"tabbar_compose_movie_neo" , @"tabbar_compose_music_neo" , @"tabbar_compose_picture_neo" , @"tabbar_compose_shopping_neo" , @"tabbar_compose_slideshow_neo" , @"tabbar_compose_topic_neo" , @"tabbar_compose_video_neo"];
    }
    
    return _imageArr;
}

-(NSMutableArray *)btnArr
{
    if(_btnArr == nil){
        
        _btnArr = [NSMutableArray array];
    }
    
    return _btnArr;
}

-(NSMutableArray *)viewArr
{
    if(_viewArr == nil){
        
        _viewArr = [NSMutableArray array];
    }
    
    return _viewArr;
}

#pragma mark 初始化
//添加毛玻璃效果
- (instancetype)init
{
    self = [super init];
    if (self) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self = [[HJVisualEffectView alloc] initWithEffect:effect];
        
        //添加控件
        [self setupSubViews];
        
        //开启箭头的动画
        [self startArrowImageAnimate];
    }
    return self;
}



#pragma mark 添加控件
//布局控件
-(void)setupSubViews
{
    //几号label
    UILabel *dayLabel = [[UILabel alloc] init];
    dayLabel.text = @"12";
    dayLabel.font = [UIFont systemFontOfSize:60];
    dayLabel.textColor = [UIColor darkGrayColor];
    _dayLabel = dayLabel;
    [self.contentView addSubview:dayLabel];
    
    //星期label
    UILabel *weekLabel = [[UILabel alloc] init];
    weekLabel.text = NSLocalizedString(@"星期一", nil);
    weekLabel.textColor = [UIColor darkGrayColor];
    _weekLabel = weekLabel;
    [self.contentView addSubview:weekLabel];

    //日期label
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"06/2017";
    dateLabel.textColor = [UIColor darkGrayColor];
    _dateLabel = dateLabel;
    [self.contentView addSubview:dateLabel];
    
    //天气label
    UILabel *weatherLabel = [[UILabel alloc] init];
    weatherLabel.text = [NSString stringWithFormat:@"%@：%@ 27℃", NSLocalizedString(@"北京", nil), NSLocalizedString(@"晴", nil)];
    weatherLabel.textAlignment = NSTextAlignmentLeft;
    weatherLabel.textColor = [UIColor darkGrayColor];
    _weatherLabel = weatherLabel;
    [self.contentView addSubview:weatherLabel];
    
    //关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn = closeBtn;
    [closeBtn setImage:[UIImage imageNamed:@"alipay_msp_close"]
              forState:UIControlStateNormal];
    [closeBtn addTarget:self
                 action:@selector(closeBtnClick)
       forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeBtn];
    
    //箭头imageView
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"common_icon_small_arrow"];
    _arrowImageView = arrowImageView;
    [self.contentView addSubview:arrowImageView];
    
    //添加页码
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 2;
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    _pageControl = pageControl;
    [self.contentView addSubview:pageControl];
    
    //功能按钮界面
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, SCROLLVIEWHEIGHT);
    _scrollView = scrollView;
    [self.contentView addSubview:scrollView];
    
    //添加功能按钮
    [self addBtnWithIndex:0];
    [self addBtnWithIndex:1];
}

//添加功能按钮
-(void)addBtnWithIndex:(NSInteger)index
{
    //添加按钮的容器控件
    UIView *view = [[UIView alloc] init];
    [self.scrollView addSubview:view];
    [self.viewArr addObject:view];
    
    //计算每个容器中按钮的个数
    NSInteger count = 8;
    
    if(index == 1){
        count = self.titleArr.count - 8;
    }
    
    //添加按钮
    for(NSInteger i = 0; i < count; i++){
        
        HJButton *btn = [HJButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:[UIImage imageNamed:self.imageArr[index * 8 + i]]
             forState:UIControlStateNormal];
        [btn setTitle:self.titleArr[index * 8 + i]
             forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(touchDown:)
      forControlEvents:UIControlEventTouchDown];
        
        //设置文字的对齐方式、字体大小和颜色
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [view addSubview:btn];
        [self.btnArr addObject:btn];
    }
}

//设置子控件的frame
-(void)layoutSubviews
{
    //几号label
    NSInteger dayLabelX = 30;
    NSInteger dayLabelY = 64;
    NSInteger dayLabelH = 70;
    NSInteger dayLabelW = 70;
    _dayLabel.frame = CGRectMake(dayLabelX, dayLabelY, dayLabelW, dayLabelH);
    
    //星期label
    NSInteger weekLabelX = dayLabelX + dayLabelW;
    NSInteger weekLabelY = dayLabelY + 10;
    NSInteger weekLabelH = 20;
    NSInteger weekLabelW = 100;
    _weekLabel.frame = CGRectMake(weekLabelX, weekLabelY, weekLabelW, weekLabelH);

    //日期label
    NSInteger dateLabelX = dayLabelX + dayLabelW;
    NSInteger dateLabelY = weekLabelY + weekLabelH + 10;
    NSInteger dateLabelH = 20;
    NSInteger dateLabelW = 100;
    _dateLabel.frame = CGRectMake(dateLabelX, dateLabelY, dateLabelW, dateLabelH);
    
    //天气label
    NSInteger weatherLabelX = dayLabelX;
    NSInteger weatherLabelY = dateLabelY + dateLabelH + 10;
    NSInteger weatherLabelH = 20;
    NSInteger weatherLabelW = 120;
    self.weatherLabel.frame = CGRectMake(weatherLabelX, weatherLabelY, weatherLabelW, weatherLabelH);
    
    //箭头imageView
    NSInteger arrowImageX = weatherLabelX + 120;
    NSInteger arrowImageY = weatherLabelY;
    NSInteger arrowImageW = 20;
    NSInteger arrowImageH = 20;
    _arrowImageView.frame = CGRectMake(arrowImageX, arrowImageY, arrowImageW, arrowImageH);
    
    //关闭按钮
    NSInteger closeBtnH = 40;
    NSInteger closeBtnW = 40;
    NSInteger closeBtnX = (self.frame.size.width - closeBtnW) * 0.5;
    NSInteger closeBtnY = self.frame.size.height - closeBtnH;
    _closeBtn.frame = CGRectMake(closeBtnX, closeBtnY, closeBtnW, closeBtnH);

    //功能按钮界面
    NSInteger scrollViewH = SCROLLVIEWHEIGHT;
    NSInteger scrollViewW = self.frame.size.width;
    NSInteger scrollViewX = 0;
    NSInteger scrollViewY = self.frame.size.height * 0.5;
    _scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    
    //页码界面
    NSInteger pageControlH = 10;
    NSInteger pageControlW = 50;
    NSInteger pageControlX = (self.frame.size.width - pageControlW) * 0.5;
    NSInteger pageControlY = self.frame.size.height - 80;
    _pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    
    //添加功能按钮以及容器控件
    NSInteger btnCount = 4; //每行按钮的个数
    NSInteger btnW = 80;    //按钮宽度
    NSInteger btnH = 80;    //按钮高度
    CGFloat btnMarginX = (self.frame.size.width - btnW * btnCount) / 5.0;   //列间隔
    CGFloat btnMarginY = 20;    //行间隔
    NSInteger viewW = self.frame.size.width;    //按钮容器的宽度
    NSInteger viewH = SCROLLVIEWHEIGHT;         //按钮容器的高度
    
    for(NSInteger i = 0; i < self.viewArr.count; i++){
        
        NSInteger viewX = i * viewW;    //按钮容器的X
        NSInteger viewY = 0;            //按钮容器的Y
        
        UIView *view = self.viewArr[i];
        
        view.frame = CGRectMake(viewX, viewY, viewW, viewH);
        
        //设置按钮的frame
        for(NSInteger j = 0; j < view.subviews.count; j++){
            
            NSInteger row = j / btnCount;       //列号
            NSInteger column = j % btnCount;    //行号
            NSInteger btnX = (btnMarginX + btnW) * column + btnMarginX;
            NSInteger btnY = (btnMarginY + btnH) * row + btnMarginY;
            
            UIButton *btn = view.subviews[j];
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
            //先隐藏按钮
            btn.transform = CGAffineTransformMakeTranslation(0, ScreenHeight);
         
        }
    }
    
    //动画显示按钮
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showBtns) userInfo:nil repeats:YES];
}

#pragma mark 添加动画
//开启箭头的动画
-(void)startArrowImageAnimate
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.translation.x";
    animation.fromValue = @0;
    animation.toValue = @10;
    animation.duration = 0.6;
    animation.autoreverses = YES;
    animation.repeatCount = CGFLOAT_MAX;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [_arrowImageView.layer addAnimation:animation forKey:nil];
    
}

//移除箭头Image的动画
-(void)removeArrowImageAnimate
{
    [_arrowImageView.layer removeAllAnimations];
}

//按钮出现的动画
-(void)showBtns
{
    if(_btnIndex == self.btnArr.count){
        [_timer invalidate];
        return;
    }
    
    UIButton *btn = self.btnArr[_btnIndex];
        
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        btn.transform = CGAffineTransformIdentity;

    } completion:^(BOOL finished) {
        
    }];
       
    _btnIndex++;
    
}

//隐藏按钮的动画
-(void)hideBtns
{
    _btnIndex--;
    
    if(_btnIndex < 0){
        [_timer invalidate];
        return;
    }
    
    UIButton *btn = self.btnArr[_btnIndex];
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        btn.transform = CGAffineTransformMakeTranslation(0, ScreenHeight);;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 按钮点击事件
//关闭按钮点击事件
-(void)closeBtnClick
{
    //移除箭头Image的动画
    [self removeArrowImageAnimate];
    
    //隐藏按钮的动画
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(hideBtns) userInfo:nil repeats:YES];
    
    //移除自身
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self removeFromSuperview];
    });
    
}

//标题按钮点击事件,动画让按钮变大，然后消失
-(void)touchDown:(HJButton *)button
{
    //使用CGAffineTransformMakeScale进行缩放会有问题，缩放之后会再次调用HJButton的layoutSubView方法
    
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"transform.scale";
//    animation.duration = 0.5;
//    animation.fromValue = @1;
//    animation.toValue = @1.2;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    
//    [button.layer addAnimation:animation forKey:nil];
    
    [UIView animateWithDuration:1 animations:^{

        button.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }completion:^(BOOL finished) {
        
        [button removeFromSuperview];
    }];
}

#pragma mark scrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / self.frame.size.width;
}

@end
