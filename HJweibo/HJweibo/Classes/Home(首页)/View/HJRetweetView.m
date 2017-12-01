//
//  HJRetweetView.m
//  HJweibo
//
//  Created by lulu on 2017/6/30.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJRetweetView.h"
#import "HJGraphicsView.h"
#import "HJWebPage.h"

@interface HJRetweetView()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property(nonatomic, strong)HJGraphicsView *graphicsView; //显示图片的View

@property(nonatomic, strong)HJWebPage *webPage; //音频、网页超连接

@end

@implementation HJRetweetView

#pragma mark 懒加载
-(HJGraphicsView *)graphicsView
{
    if(_graphicsView == nil){
        
        _graphicsView = [[HJGraphicsView alloc] init];
        [self addSubview:_graphicsView];
    }
    
    return _graphicsView;
}

-(HJWebPage *)webPage
{
    if(_webPage == nil){
        
        HJWebPage *webPage = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HJWebPage class]) owner:nil options:nil].lastObject;
        _webPage = webPage;
        [self addSubview:webPage];
    }
    
    return _webPage;
}

//重写set方法，
-(void)setStatus:(HJStatus *)status
{
    _status = status;
    
    //转发微博文字内容
    NSString *retweetText = status.retweeted_status.text;
    //微博转发自哪个用户
    NSString *retweetUserName = status.retweeted_status.user.screen_name;
    //转发微博应该显示的内容
    self.contentLabel.text = [NSString stringWithFormat:@"@%@:%@", retweetUserName, retweetText];
    
    /*
     微博、转发微博只会存在以下几种情况
     
     文字 + 图片
     文字 + 网页、视频、音频链接
     */
    
    //转发的微博有图片
    if(status.retweeted_status.pic_urls.count != 0){
        
        self.graphicsView.hidden = NO;
        self.webPage.hidden = YES;
        
        self.graphicsView.isRetweet = YES;
        self.graphicsView.status = status;
        self.graphicsView.frame = status.retweetGraphicsViewFrame;
    }
    
    //转发的微博有网页、视频、音频链接
    else if(status.retweeted_status.page_type == PageTypeAudio   ||
            status.retweeted_status.page_type == PageTypeWeb     ||
            status.retweeted_status.page_type == PageTypeVideo   ||
            status.retweeted_status.page_type == PageTypeText)
    {
        self.webPage.hidden = NO;
        self.graphicsView.hidden = YES;
        
        self.webPage.frame = status.webPageFrame;
        self.webPage.infoModel = status.retweeted_status.urlInfomodel;
    }else{
        
        self.webPage.hidden = YES;
        self.graphicsView.hidden = YES;
    }
}

@end
