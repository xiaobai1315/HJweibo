//
//  HJTools.m
//  HJweibo
//
//  Created by Jermy on 2017/6/28.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJTools.h"
#import "HJGetImageSize.h"
#import <time.h>

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

//获取微博授权秘钥
-(NSString *)getAccessToken
{
    static NSString *accessToken;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HJAccountModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountCachePath];
        accessToken = account.access_token;
    });
    
    return accessToken;
}

//从ResourceWeibo.bundle中取图片
-(UIImage *)getWeiboImage:(NSString *)imageName
{
    static NSString *bundlePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundlePath = [[NSBundle mainBundle] pathForResource:@"ResourceWeibo" ofType:@"bundle"];
    });
    
    NSString *imagePath = [bundlePath stringByAppendingPathComponent:imageName];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

//获取微博发布时间,转换成 刚刚 几分钟前 几个小时前 形式 通过C的方式，比NSDateFormatter效率要快
// Tue Jun 27 09:36:54 +0800 2017
-(NSString *)convertTime:(NSString *)publishTime
{
    struct tm tm;
    const char *format = "%a %b %d %H:%M:%S %z %Y";
    strptime([publishTime cStringUsingEncoding:NSUTF8StringEncoding], format, &tm);
    
    tm.tm_isdst = -1;
    time_t time = mktime(&tm);
    
    //获取微博发布时间到1970年的时间间隔
    //    NSTimeInterval publishInteval = time + [[NSTimeZone localTimeZone] secondsFromGMT];
    NSTimeInterval publishInteval = time;
    
    //获取本地时间到1970年的时间间隔
    NSTimeInterval currentInteval = [[NSDate date] timeIntervalSince1970];
    
    //获取发布时间到现在的秒数
    NSTimeInterval interval = currentInteval - publishInteval;
    
    NSString *result = @"";
    NSInteger tempTime = 0;
    //1分钟之内
    if (interval < WBMINTUE) {
        
        result = @"刚刚";
    }
    
    //1小时之内
    else if ((interval >= WBMINTUE) && (interval < WBHOUR)) {
        
        tempTime = interval / WBMINTUE;
        result = [NSString stringWithFormat:@"%zd分钟前", tempTime];
    }
    
    //1天之内
    else if ((interval >= WBHOUR) && (interval < WBDAY)){
        
        tempTime = interval / WBHOUR;
        result = [NSString stringWithFormat:@"%zd小时前", tempTime];
    }
    
    //1个月之内
    else if ((interval >= WBDAY) && (interval < WBMONTH)){
        
        tempTime = interval / WBDAY;
        result = [NSString stringWithFormat:@"%zd天前", tempTime];
    }
    
    //1年之内
    else if ((interval >= WBMONTH) && (interval < WBYEAR)){
        
        tempTime = interval / WBMONTH;
        result = [NSString stringWithFormat:@"%zd个月前", tempTime];
    }
    
    //n年前
    else{
        
        tempTime = interval / WBYEAR;
        result = [NSString stringWithFormat:@"%zd年前", tempTime];
    }
    
    return result;
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

//处理成圆形图片
-(UIImage *)circleImageWithSize:(CGSize)size image:(UIImage *)image
{
    //处理 CGContextAddPath: invalid context 0x0 的问题
    if(size.height <= 0 || size.width <= 0){
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path addClip];
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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

//匹配字符串的正则表达式
-(NSArray *)regularExpressionWithString:(NSString *)string pattern:(NSString *)pattern
{
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:nil];
    
    __block NSMutableArray *linkArray = [NSMutableArray array];
    
    [regular enumerateMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        NSRange range = result.range;
        NSString *text = [string substringWithRange:range];
        
        if(text.length > 0){
            HJLinkModel *model = [HJLinkModel linkModelWithText:text range:range];
            [linkArray addObject:model];
        }
    }];

    return linkArray;
}

/*
 weibo.app 里面的正则，有兴趣的可以参考下：
 
 HTTP链接 (例如 http://www.weibo.com ):
 ([hH]ttp[s]{0,1})://[a-zA-Z0-9\.\-]+\.([a-zA-Z]{2,4})(:\d+)?(/[a-zA-Z0-9\-~!@#$%^&*+?:_/=<>.',;]*)?
 ([hH]ttp[s]{0,1})://[a-zA-Z0-9\.\-]+\.([a-zA-Z]{2,4})(:\d+)?(/[a-zA-Z0-9\-~!@#$%^&*+?:_/=<>]*)?
 (?i)https?://[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+([-A-Z0-9a-z_\$\.\+!\*\(\)/,:;@&=\?~#%]*)*
 ^http?://[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+(\/[\w-. \/\?%@&+=\u4e00-\u9fa5]*)?$
 
 链接 (例如 www.baidu.com/s?wd=test ):
 ^[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+([-A-Z0-9a-z_\$\.\+!\*\(\)/,:;@&=\?~#%]*)*
 
 邮箱 (例如 sjobs@apple.com ):
 \b([a-zA-Z0-9%_.+\-]{1,32})@([a-zA-Z0-9.\-]+?\.[a-zA-Z]{2,6})\b
 \b([a-zA-Z0-9%_.+\-]+)@([a-zA-Z0-9.\-]+?\.[a-zA-Z]{2,6})\b
 ([a-zA-Z0-9%_.+\-]+)@([a-zA-Z0-9.\-]+?\.[a-zA-Z]{2,6})
 
 电话号码 (例如 18612345678):
 ^[1-9][0-9]{4,11}$
 
 At (例如 @王思聪 ):
 @([\x{4e00}-\x{9fa5}A-Za-z0-9_\-]+)
 
 话题 (例如 #奇葩说# ):
 #([^@]+?)#
 
 表情 (例如 [呵呵] ):
 \[([^ \[]*?)]
 
 匹配单个字符 (中英文数字下划线连字符)
 [\x{4e00}-\x{9fa5}A-Za-z0-9_\-]
 
 匹配回复 (例如 回复@王思聪: ):
 \x{56de}\x{590d}@([\x{4e00}-\x{9fa5}A-Za-z0-9_\-]+)(\x{0020}\x{7684}\x{8d5e})?:
 
 */
@end
