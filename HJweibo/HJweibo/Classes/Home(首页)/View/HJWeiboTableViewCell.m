//
//  HJWeiboTableViewCell.m
//  HJweibo
//
//  Created by Jermy on 2017/6/26.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJWeiboTableViewCell.h"
#import "HJGraphicsView.h"
#import "HJRetweetView.h"
#import "HJWebPage.h"

@interface HJWeiboTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabelView;       //用户昵称
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;     //微博发布时间
@property (weak, nonatomic) IBOutlet UILabel *publishPlatform;      //微博发布平台
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;         //微博内容
@property (weak, nonatomic) IBOutlet UIButton *retweetBtn;          //转发按钮
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;          //评论按钮
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;             //喜欢按钮
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;    //头像
@property (weak, nonatomic) IBOutlet UIImageView *vipIcon;          //VIP图标

@property (nonatomic, strong) HJGraphicsView *graphicsView;           //显示图片的View
@property (nonatomic, strong) HJRetweetView *retweetView;             //转发微博的View
@property (nonatomic, strong) HJWebPage *webPage;                     //转发微博的原文链接

@end

@implementation HJWeiboTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageView.layer.shouldRasterize = YES;
    self.iconImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;;
}

#pragma mark 懒加载
//显示图片的View
-(HJGraphicsView *)graphicsView
{
    if(_graphicsView == nil){
        
        HJGraphicsView *graphicsView = [[HJGraphicsView alloc] init];
        _graphicsView = graphicsView;
        [self.contentView addSubview:graphicsView];
    }
    
    return _graphicsView;
}

//显示转发微博的View
-(HJRetweetView *)retweetView
{
    if(_retweetView == nil){
        
        HJRetweetView *retweetView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HJRetweetView class]) owner:nil options:nil].lastObject;
        _retweetView = retweetView;
        [self.contentView addSubview:retweetView];
    }
    
    return _retweetView;
}

-(HJWebPage *)webPage
{
    if(_webPage == nil){
        
        HJWebPage *webPage = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HJWebPage class]) owner:nil options:nil].lastObject;
        _webPage = webPage;
        [self.contentView addSubview:webPage];
    }
    
    return _webPage;
}

#pragma mark 初始化
//重写set方法，设置微博显示的内容
-(void)setStatus:(HJStatus *)status
{
    _status = status;
    
    //设置用户昵称
    self.titleLabelView.text = status.user.screen_name;
    
    //设置用户头像
    [self.iconImageView setCircleHeaderWithUrl:status.user.avatar_large];
    
    //设置微博文本内容
    [self setWeiboContentWithText:status.text];
    
    //微博发布平台
    self.publishPlatform.text = [[HJTools shareManager] getPlatformSource:status.source];
    
    //获取微博发布时间
    self.publishTimeLabel.text = [[HJTools shareManager] convertTime:status.created_at];
    
    //设置按钮标题
    [self.retweetBtn setTitle:[NSString stringWithFormat:@"%zd", status.reposts_count] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%zd", status.comments_count] forState:UIControlStateNormal];
    [self.loveBtn setTitle:[NSString stringWithFormat:@"%zd", status.attitudes_count] forState:UIControlStateNormal];
    
    /*
     微博、转发微博只会存在以下几种情况
     
     文字 + 图片
     文字 + 网页、视频、音频链接
     文字 + 转发微博
     */
    
    //文字 + 图片
    if(status.pic_urls.count > 0)
    {
        self.graphicsView.hidden = NO;
        self.retweetView.hidden = YES;
        self.webPage.hidden = YES;
        
        self.graphicsView.isRetweet = NO;
        self.graphicsView.status = status;
        self.graphicsView.frame = status.graphicsViewFrame;
    }
    
    //文字 + 网页、视频、音频链接
    else if(status.page_type == PageTypeAudio   ||
            status.page_type == PageTypeWeb     ||
            status.page_type == PageTypeVideo   ||
            status.page_type == PageTypeText)
    {
        self.webPage.hidden = NO;
        self.retweetView.hidden = YES;
        self.graphicsView.hidden = YES;
        
        self.webPage.infoModel = status.urlInfomodel;
        self.webPage.frame = status.webPageFrame;
    }
    
    //文字 + 转发微博
    else{
        self.retweetView.hidden = NO;
        self.webPage.hidden = YES;
        self.graphicsView.hidden = YES;
        
        self.retweetView.status = status;
        self.retweetView.frame = status.retweetViewFrame;
    }
}

//重写setFrame方法，让cell之间多出10个像素的间隔
-(void)setFrame:(CGRect)frame
{
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y + 12, frame.size.width, frame.size.height - 11);
    
    [super setFrame: rect];
}

//将文字转换成带emotion表情的富文本
-(void)setWeiboContentWithText:(NSString *)text
{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        //去掉文本中的http连接地址
//        NSString *content = [[HJTools shareManager] deleteHttpStr:text];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            self.contentLabel.text = content;
//        });
//        
//        NSMutableAttributedString *resultAttributeString = [[NSMutableAttributedString alloc] initWithString:content];
//        
//        //替换超链接文本
//        NSArray *array = [self getRichTextRange:content withType:HJRichTextTypeHyperlink];
//        if(array.count != 0){
//            
//            for(NSValue *value in array){
//                
//                NSRange range = value.rangeValue;
//                
//                [resultAttributeString addAttributes: @{ NSForegroundColorAttributeName: [UIColor blueColor] } range: range];
//                [resultAttributeString addAttribute:NSLinkAttributeName value:@"http://www.baidu.com" range:range];
//            }
//        }
//        
//        //替换emoji表情
//        NSArray *emotions = [self getRichTextRange:content withType:HJRichTextTypeEmoji];
//        if(emotions.count != 0){
//         
//            //从缓存中取出emotion表情对应的图片的URL地址
//            NSArray *cacheArray = [NSArray arrayWithContentsOfFile:EmotionCachePath];
//            NSArray *emotionArr = [HJEmotionModel mj_objectArrayWithKeyValuesArray:cacheArray];
//            
//            for(NSInteger i = emotions.count - 1; i >= 0; i--){
//                
//                NSValue *value = emotions[i];
//                NSRange emotionRange = value.rangeValue;
//                
//                //获取emotion表情字符串
//                NSString *emotionStr = [content substringWithRange:emotionRange];
//                NSString *emotionUrl = @"";
//                
//                for(HJEmotionModel *model in emotionArr){
//                    if([model.value isEqualToString:emotionStr]){
//                        emotionUrl = model.url;
//                        break;
//                    }
//                }
//                
//                //判断emotion地址是否为空
//                if(emotionUrl.length == 0){
//                    
//                    continue;
//                }
//                
//                //图片地址前加上http
//                emotionUrl = [NSString stringWithFormat:@"%@", emotionUrl];
//                
//                //下载图片
//                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:emotionUrl] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                    
//                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                    
//                    //创建图片附件
//                    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
//                    attach.image = image;
//                    attach.bounds = CGRectMake(0, 0, 15, 15);
//                    
//                    //创建emotion表情富文本
//                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
//                    
//                    //替换emotion表情
//                    [resultAttributeString replaceCharactersInRange:emotionRange withAttributedString:attrString];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        self.contentLabel.attributedText = resultAttributeString;
//                    });
//                    
//                }];
//            }
//        }
//    });
}

//获取文本中的emotion表情的range，emotion可能存在多个
-(NSArray *)getRichTextRange:(NSString *)content withType:(HJRichTextType) type
{
    unichar leftSearchStr = '[';
    unichar rightSearchStr = ']';
    
    if(type == HJRichTextTypeHyperlink){
        leftSearchStr = '#';
        rightSearchStr = '#';
    }
    
    NSMutableArray *emotionArr = [NSMutableArray array];
    
    NSInteger leftIndex = 0;
    NSInteger rightIndex = 0;
    BOOL hasFindLeftIndex = NO;
    
    for(NSInteger index = 0; index < content.length; index++){
        
        //查找[
        if([content characterAtIndex:index] == leftSearchStr){
            
            if(type == HJRichTextTypeHyperlink){
                
                if(hasFindLeftIndex == NO){
                    
                    hasFindLeftIndex = YES;
                    leftIndex = index;
                }else{
                    
                    rightIndex = index;
                    
                    NSRange range = NSMakeRange(leftIndex, rightIndex - leftIndex + 1);
                    [emotionArr addObject:[NSValue valueWithRange:range]];
                    
                    //清空存储的index
                    leftIndex = 0;
                    rightIndex = 0;
                    hasFindLeftIndex = NO;
                }
                
                continue;
            }else{
                hasFindLeftIndex = YES;
                leftIndex = index;
                continue;
            }
        }
        
        //查找]
        else if([content characterAtIndex:index] == rightSearchStr){
            
            if(hasFindLeftIndex){
                
                rightIndex = index;
                
                NSRange range = NSMakeRange(leftIndex, rightIndex - leftIndex + 1);
                [emotionArr addObject:[NSValue valueWithRange:range]];
                
                //清空存储的index
                leftIndex = 0;
                rightIndex = 0;
                hasFindLeftIndex = NO;
            }
            
            continue;
        }
    }

    return emotionArr;
}

#pragma mark 按钮点击事件

- (IBAction)retweetBtnClick:(id)sender {
}
- (IBAction)commentBtnClick:(id)sender {
}
- (IBAction)loveBtnClick:(id)sender {
}

@end
