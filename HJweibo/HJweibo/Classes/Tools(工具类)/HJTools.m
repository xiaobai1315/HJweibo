//
//  HJTools.m
//  HJweibo
//
//  Created by Jermy on 2017/6/28.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJTools.h"
#import "HJGetImageSize.h"

@implementation HJTools
{
    BOOL done;
}

//单例
static HJTools *_instance;

+(instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

-(id)copy
{
    return _instance;
}

#pragma mark 工具

//获取微博发布平台
//<a href="http://app.weibo.com/t/feed/6vtZb0" rel="nofollow">微博 weibo.com</a>
-(NSString *)getPlatformSource:(NSString *)source
{
    //获取 \> 的位置
    NSRange startRange = [source rangeOfString:@"\">"];
    
    //获取   的位置
    NSRange endRange = [source rangeOfString:@"</a>"];
    
    //如果没有 \> 或 </a> 标识，返回空
    if(startRange.length == 0 || endRange.length == 0){
        
        return @"";
    }
    
    //获取 发布平台 的位置
    NSRange sourceRange = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    
    return [source substringWithRange:sourceRange];
}

//获取微博发布时间,转换成 刚刚 几分钟前 几个小时前 形式
// Tue Jun 27 09:36:54 +0800 2017
-(NSString *)getPublishTime:(NSString *)publishTime
{
    //设置日期格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss ZZZ yyyy";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    //将字符串日期转成date
    NSDate *date = [formatter dateFromString:publishTime];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:
                                    NSCalendarUnitYear      |
                                    NSCalendarUnitMonth     |
                                    NSCalendarUnitDay       |
                                    NSCalendarUnitHour      |
                                    NSCalendarUnitMinute    |
                                    NSCalendarUnitSecond
                                               fromDate:date];
    
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComponents = [calendar components:
                                           NSCalendarUnitYear      |
                                           NSCalendarUnitMonth     |
                                           NSCalendarUnitDay       |
                                           NSCalendarUnitHour      |
                                           NSCalendarUnitMinute    |
                                           NSCalendarUnitSecond
                                                      fromDate:currentDate];
    
    NSString *result = @"";
    
    //比较年
    if(components.year != currentComponents.year){
        
        result = [NSString stringWithFormat:@"%zd年前", currentComponents.year - components.year];
    }
    
    //比较月
    else if(components.month != currentComponents.month){
        
        result = [NSString stringWithFormat:@"%zd月前", currentComponents.month - components.month];
    }
    
    //比较日
    else if(components.day != currentComponents.day){
        
        result = [NSString stringWithFormat:@"%zd天前", currentComponents.day - components.day];
    }
    
    //比较小时
    else if(components.hour != currentComponents.hour){
        
        result = [NSString stringWithFormat:@"%zd小时前", currentComponents.hour - components.hour];
    }
    
    //比较分钟
    else if(components.minute != currentComponents.minute){
        
        result = [NSString stringWithFormat:@"%zd分钟前", currentComponents.minute - components.minute];
    }
    
    //不到1分钟
    else{
        
        result = @"刚刚";
    }
    
    return result;
}

// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}
//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取gif图片的大小
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

//删除文本中的HTTP连接,文本中有可能存在多个http地址
-(NSString *)deleteHttpStr:(NSString *)text
{
    
    NSString *temp = text;
    
    while (1) {
        
        NSRange range = [temp rangeOfString:@"http://"];
        if(range.length == 0){
            
            break;
        }
        
        temp = [self removeHTTPStr:temp];
    }
    
    return temp;
}

-(NSString *)removeHTTPStr:(NSString *)text
{
    NSRange range = [text rangeOfString:@"http://"];
    
    //截取连接文本,连续取字符，遇到空格停止
    NSInteger startIndex = range.location + range.length;
    NSInteger length = 0;
    
    for(NSInteger i = 0; i < text.length - startIndex; i++){
        
        NSRange subStrRange = NSMakeRange(startIndex + i, 1);
        
        NSString *subStr = [text substringWithRange:subStrRange];
        
        if([subStr isEqualToString:@" "] || [subStr isEqualToString:@"["]){
            
            break;
        }
        
        length++;
    }
    
    //截取连接地址
    NSRange subStringRange = NSMakeRange(range.location, range.length + length);
    
    NSString *newStr = [text stringByReplacingCharactersInRange:subStringRange withString:@""];
    
    return newStr;
}
@end
