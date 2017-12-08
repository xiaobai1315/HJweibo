//
//  HJWeiboModel.m
//  HJweibo
//
//  Created by Jermy on 2017/12/1.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJWeiboModel.h"

@implementation HJLinkModel

-(instancetype)initWithText:(NSString *)text range:(NSRange)range
{
    self = [super init];
    self.linkText = text;
    self.linkRange = range;
    return self;
}

+(instancetype)linkModelWithText:(NSString *)text range:(NSRange)range
{
    return [[self alloc] initWithText:text range:range];
}

@end

@implementation HJUserModel

@end

@implementation HJURLInfoModel

@end

@implementation HJURLInfoImageModel

@end

@implementation HJStatus

//返回cell的高度
-(CGFloat)cellHeight
{
    return 0;
}

//根据文本内容计算文本高度
-(CGFloat)calculateTextHeight:(NSString *)text fontSize:(NSInteger) fontSize
{
    CGSize boundSize = CGSizeMake(ScreenWidth - 20, MAXFLOAT);
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont systemFontOfSize:fontSize]
                                 };
    
    CGRect textRect = [text boundingRectWithSize:boundSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    
    return textRect.size.height;
}

//根据图片个数计算graphicsView的size
-(CGSize)calculateGraphicsViewSize:(NSArray *) pic_urls
{
    __block CGFloat height = 0;
    __block CGFloat width = 0;
    
    NSInteger pictureCount = pic_urls.count;
    
    //1张图片，
    if(pictureCount == 1){
        
        NSString *imageUrl = pic_urls.lastObject[@"thumbnail_pic"];
        
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        
        if(imageUrl.length == 0){
            return CGSizeMake(0, 0);
        }
        
        //获取图片大小
        CGSize size = [HJTools getImageSizeWithURL:imageUrl];
        CGFloat imageHeight = size.height;
        CGFloat imageWidth = size.width;
        
        //如果是长图，长度、宽度固定
        if(imageHeight > ScreenHeight){
            
            width = SingalImageViewW;
            height = SingalImageViewW * 4 / 3;
        }
        
        //照片高度>宽度
        else if(imageHeight >= imageWidth){
            
            width = SingalImageViewW;
            height = imageHeight * width / imageWidth;
        }else{
            
            height = SingalImageViewW;
            width = imageWidth * height / imageHeight;
        }
    }
    
    //多张图片
    else{
        
        if(pictureCount % 3 == 0){
            
            height = (pictureCount / 3) * (ImageViewW + HJMargin) - HJMargin;
        }else{
            
            height = (pictureCount / 3 + 1) * (ImageViewW + HJMargin) - HJMargin;
        }
        
        width = ScreenWidth - HJMargin * 2;
    }
    
    return CGSizeMake(width, height);
}

//计算转发微博View的高度
-(CGFloat)calculateRetweetViewHeight
{
    CGFloat height = 0;
    
    height += HJMargin;
    
    /*** 转发微博文字内容的高度 ***/
    //转发微博文字内容
    NSString *retweetText = _retweeted_status.text;
    //微博转发自哪个用户
    NSString *retweetUserName = _retweeted_status.user.screen_name;
    //转发微博应该显示的内容
    NSString *content = [NSString stringWithFormat:@"@%@:%@", retweetUserName, retweetText];
    //转发微博内容的高度
    height += [self calculateTextHeight:content fontSize:RetweetWeiboContentFontSize];
    
    height += HJMargin;
    
    //如果微博中同时存在短连接和图片，显示图片
    if(_retweeted_status.pic_urls.count == 0){
        
        if(_retweeted_status.page_type == PageTypeAudio || _retweeted_status.page_type == PageTypeWeb || _retweeted_status.page_type == PageTypeText){
            
            self.retweetWebPageFrame = CGRectMake(HJMargin, height, PageWidth, WebPageHeight);
            
            height += WebPageHeight;
            
            height += HJMargin;
            
            //获取短连接信息
            [self getShorturlInfo:_retweeted_status.text isRetweet:YES];
            
        }else{
            if(_retweeted_status.page_type != 0){
                
                NSLog(@"为了找到视频的pageType-%zd", _retweeted_status.page_type);
            }
        }
    }
    
    /*** 转发微博图片的高度 ***/
    else{
        
        //计算图片View的高度和宽度
        CGSize retweetViewSize = [self calculateGraphicsViewSize:_retweeted_status.pic_urls];
        //计算转发微博图片View的frame
        self.retweetGraphicsViewFrame = CGRectMake(HJMargin, height, retweetViewSize.width, retweetViewSize.height);
        
        height += retweetViewSize.height;
        
        height += HJMargin;
    }
    
    return height;
}

//判断文本中是否含有http链接地址
-(BOOL)weiboContentHasShortUrl:(NSString *)weiboContent
{
    NSRange range = [weiboContent rangeOfString:@"http://"];
    if(range.length == 0){
        
        return NO;
    }
    
    return YES;
}

//判断文本中是否含有话题
-(BOOL)weiboContentHasTopic:(NSString *)weiboContent
{
    NSRange range = [weiboContent rangeOfString:@"#"];
    if(range.length == 0){
        
        return NO;
    }
    
    return YES;
}

//解析微博文本，如果文本内容中有链接，获取短连接的信息
-(void)getShorturlInfo:(NSString *)weiboContent isRetweet:(BOOL)isRetweet
{
    //获取连接地址
    NSRange range = [weiboContent rangeOfString:@"http://"];
    if(range.length == 0){
        
        return;
    }
    
    //截取连接文本,连续取字符，遇到空格停止
    NSInteger startIndex = range.location + range.length;
    NSInteger length = 0;
    
    for(NSInteger i = 0; i < weiboContent.length - startIndex; i++){
        
        NSRange subStrRange = NSMakeRange(startIndex + i, 1);
        
        NSString *subStr = [weiboContent substringWithRange:subStrRange];
        
        if([subStr isEqualToString:@" "]){
            
            break;
        }
        
        length++;
    }
    
    //截取连接地址
    NSRange subStringRange = NSMakeRange(range.location, range.length + length);
    
    NSString *subString = [weiboContent substringWithRange:subStringRange];
    
    //短连接转长连接，获取连接类型
    HJAccountModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountCachePath];
    
    NSDictionary *para = @{
                           @"access_token" :  account.access_token,
                           @"url_short" :   subString
                           };
    
    [[AFHTTPSessionManager manager] GET:shortUrlInfo parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //        NSLog(@"%@", responseObject);
        
        NSArray *urls = responseObject[@"urls"];
        if(urls.count == 0){
            return ;
        }
        
        NSArray *annotations = urls[0][@"annotations"];
        if(annotations.count == 0){
            return ;
        }
        
        NSDictionary *object = annotations[0][@"object"];
        
        if(isRetweet){
            _retweeted_status.urlInfomodel = [HJURLInfoModel mj_objectWithKeyValues:object];
        }else{
            _urlInfomodel = [HJURLInfoModel mj_objectWithKeyValues:object];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//获取微博话题的信息， #...#
-(void)getTopicInfo:(NSString *)weiboContent
{
    NSInteger startIndex = -1;
    NSInteger endIndex = -1;
    
    for(NSInteger index = 0; index < weiboContent.length; index++){
        
        unichar c = [weiboContent characterAtIndex:index];
        
        if(c == '#'){
            
            if(startIndex == -1){
                //找到第一个“#”
                startIndex = index;
                continue;
            }else{
                
                //找到第二个 #
                endIndex = index;
                break;
            }
        }
    }
    
    //微博文本内容中不存在话题
    if(startIndex == -1 || endIndex == -1){
        
        return;
    }
    
    if(startIndex == endIndex || startIndex == endIndex + 1){
        
        return;
    }
    
    //截取话题内容
    NSRange range = NSMakeRange(startIndex, endIndex - startIndex + 1);
    
    NSString *topic = [weiboContent substringWithRange:range];
    
    NSLog(@"%@", topic);
}

@end
