//
//  HJGraphicsView.m
//  HJweibo
//
//  Created by Jermy on 2017/6/28.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJGraphicsView.h"
#import "HJStatus.h"

@interface HJGraphicsView()<CAAnimationDelegate>

@property(nonatomic, copy)NSArray *picArray;    //存放照片地址的数组
@property(nonatomic, copy)NSMutableArray *imageViewArray;    //存放imageView的数组
@property(nonatomic, copy)NSMutableArray *animateImageArray;    //存放gif图片模型
@property(nonatomic, copy)NSMutableArray *animateImageViewIndexArray;    //存放显示GIF的imageView
@end

@implementation HJGraphicsView
{
    NSInteger _animateIndex;    //记录当前执行动画的序号
}

#pragma mark 懒加载

-(NSArray *)picArray
{
    if(_picArray == nil){
        _picArray = [NSArray array];
    }
    
    return _picArray;
}

-(NSMutableArray *)imageViewArray
{
    if(_imageViewArray == nil){
        _imageViewArray = [NSMutableArray array];
    }
    
    return _imageViewArray;
}

-(NSMutableArray *)animateImageArray
{
    if(_animateImageArray == nil){
        
        _animateImageArray = [NSMutableArray array];
    }
    
    return _animateImageArray;
}

-(NSMutableArray *)animateImageViewIndexArray
{
    if(_animateImageViewIndexArray == nil){
        
        _animateImageViewIndexArray = [NSMutableArray array];
    }
    
    return _animateImageViewIndexArray;
}

#pragma mark 初始化

-(instancetype)init
{
    if(self = [super init]){
                
        [self setupSubViews];
    }
    
    return self;
}

//添加子控件
-(void)setupSubViews
{
    for(NSInteger i = 0; i < 9; i++){
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
        
        [self addSubview:imageView];
        [self.imageViewArray addObject:imageView];
    }
}

//重写set方法
-(void)setStatus:(HJStatus *)status
{
    _status = status;
    
    self.picArray = [self convertDictionaryToArray:status.pic_urls];
    
    if(_isRetweet){
        self.picArray = [self convertDictionaryToArray:status.retweeted_status.pic_urls];
    }
    
    [self setupImage];
    
//    if(self.animateImageViewIndexArray.count > 0){
//    
//        [self beginImageViewAnimation];
//    }
}

//将字典数组转换成数组
-(NSArray *)convertDictionaryToArray:(NSArray *)picArray
{
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for(NSDictionary *dict in picArray){
        
        NSString *picUrl = dict[@"thumbnail_pic"];
        
        if(picUrl == nil){
            continue;
        }
        
        [tempArr addObject:picUrl];
    }
    
    return tempArr;
}

//给imageView设置图片
-(void)setupImage
{
    for(NSInteger i = 0; i < self.imageViewArray.count; i++){
        
        UIImageView *imageView = self.imageViewArray[i];
        
        NSInteger picCount = _status.pic_urls.count;
        
        if(self.isRetweet){
            picCount = _status.retweeted_status.pic_urls.count;
        }
        
        //超出图片数量的imageView 隐藏
        if(i >= picCount){
            
            imageView.hidden = YES;
            continue;
        }
        
        //下载中等质量的图片
        NSString *tempStr = @"";
        
        if(self.isRetweet){
            tempStr = _status.retweeted_status.pic_urls[i][@"thumbnail_pic"];
        }else{
            tempStr = _status.pic_urls[i][@"thumbnail_pic"];
        }
        
        tempStr = [tempStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];

        //设置图片
        imageView.hidden = NO;
        
        //如果是GIF动态图片
        if([tempStr hasSuffix:@".gif"]){
            
//            tempStr = @"http://wx1.sinaimg.cn/thumbnail/89318f8cgy1fi3bbm3ht3g207505kx6p.gif";
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:tempStr] options: 0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                //保存GIF图片
                [self.animateImageArray addObject:image];
                //保存imageView的序号
                [self.animateImageViewIndexArray addObject:[NSNumber numberWithInteger:i]];
                
                //设置imageView的图片

                UIImage *temp = image.images[0];
            
                if(temp == nil){
                    imageView.image = image;
                }else{
                    imageView.image = temp;
                }
                
                //让imageView重新布局
//                    [self setNeedsDisplay];
//                });
            }];
        }
        
        //非动态图片
        else{
            [imageView sd_setImageWithURL:[NSURL URLWithString:tempStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                //如果图片的尺寸超过屏幕高度，认为是长图片
                if(image.size.height > ScreenHeight){
                    imageView.contentMode = UIViewContentModeCenter | UIViewContentModeScaleAspectFit;
                }else{
                    imageView.contentMode = UIViewContentModeScaleToFill;
                }
                
                //让imageView重新布局
                [self setNeedsDisplay];
            }];
        }
    }
}

/*
 *  设置控件的frame
 *  控件的排列规则:
 *  1张图片，按照图片尺寸显示
 *  2张、3张图片，按照一行显示3张图片的宽度显示在一行
 *  4张图片，按照一行显示3张图片的宽度显示在一行，每行显示2张图片
 *  5张及以上，按照一行显示3张图片的宽度显示，每行最多显示3张图片
 */
-(void)layoutSubviews
{
    CGFloat imageViewW = ImageViewW;   //imageView的宽度
    CGFloat imageViewH = ImageViewW;        //imageView的高度
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    
    //1张图片
    if(self.picArray.count == 1){
        
        imageViewH = _status.graphicsViewFrame.size.height;
        imageViewW = _status.graphicsViewFrame.size.width;
        
        if(self.isRetweet){
            imageViewH = _status.retweetGraphicsViewFrame.size.height;
            imageViewW = _status.retweetGraphicsViewFrame.size.width;
        }
    }
    
    //设置imageView的frame
    for (NSInteger i = 0; i < self.imageViewArray.count; i++) {
        
        UIImageView *imageView = self.imageViewArray[i];
        
        //如果imageView是隐藏状态，退出
        if(imageView.hidden == YES){
            
            return;
        }
        
        NSInteger column = i % 3;   //列号
        NSInteger row    = i / 3;   //行号
        
        //4张图片
        if(self.picArray.count == 4){
            
            column = i % 2;   //列号
            row    = i / 2;   //行号
        }
        
        imageViewX = (HJMargin + imageViewW) * column;
        imageViewY = (HJMargin + imageViewW) * row;
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    }
}

//开始imageView动画
-(void)beginImageViewAnimation
{
    NSNumber *temp = self.animateImageViewIndexArray[_animateIndex];
    NSInteger index = temp.integerValue;
    
    //取出imageView
    UIImageView *imageView = self.imageViewArray[index];
    
    //取出GIF图片
    UIImage *gifImage = self.animateImageArray[_animateIndex];
    
    //创建动画
    [self imageViewAnimate:imageView withImage:gifImage];

}

//创建imageView动画
-(void)imageViewAnimate:(UIImageView *)imageView withImage:(UIImage *)image
{
    //创建动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.duration = image.duration;
    animation.delegate = self;
    
    NSMutableArray *array = [NSMutableArray array];
    
    for(UIImage *tempImage in image.images){
        
        CGImageRef imageRef = tempImage.CGImage;
        
        [array addObject:(__bridge id _Nonnull)(imageRef)];
    }
    
    animation.values = array;
    
    [imageView.layer addAnimation:animation forKey:nil];
}

#pragma mark 动画代理
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _animateIndex++;
    
    if(_animateIndex > self.animateImageViewIndexArray.count){
        
        _animateIndex = 0;
    }
    
    [self beginImageViewAnimation];
}
@end
