//
//  HJCameraShowPhotoView.m
//  HJweibo
//
//  Created by Jermy on 2017/6/23.
//  Copyright © 2017年 Jermy. All rights reserved.
//  显示拍照后的照片

#import "HJCameraShowPhotoView.h"

@interface HJCameraShowPhotoView()

@property(nonatomic, weak)UIImageView *imageView;   //显示照片
@property(nonatomic, weak)UIImage *image;
@property(nonatomic, weak)UIButton *savePhotoBtn;   //保存照片
@property(nonatomic, weak)UIButton *cancelBtn;      //取消按钮
@end

@implementation HJCameraShowPhotoView

#pragma mark 初始化

+(instancetype)showPhotoViewWithImage:(UIImage *)image
{
    return [[self alloc] initWithImage:image];
}

-(instancetype)initWithImage:(UIImage *)image
{
    if(self = [super init]){
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor whiteColor];
        _image = image;
        [self setupSubViews];
    }
    
    return self;
}

#pragma mark 初始化控件
//创建子控件
-(void)setupSubViews
{
    //显示照片的imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = _image;
    _imageView = imageView;
    [self addSubview:imageView];
    
    //保存照片按钮
    UIButton *savePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [savePhotoBtn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [savePhotoBtn addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    _savePhotoBtn = savePhotoBtn;
    [self addSubview:savePhotoBtn];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSavePhoto) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn = cancelBtn;
    [self addSubview:cancelBtn];
    
}

//设置子控件的frame
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //显示照片的imageView
    self.imageView.frame = self.bounds;
    
    //保存照片按钮
    NSInteger savePhotoBtnH = 40;
    NSInteger savePhotoBtnW = 100;
    NSInteger savePhotoBtnX = 50;
    NSInteger savePhotoBtnY = ScreenHeight - 100;
    
    self.savePhotoBtn.frame = CGRectMake(savePhotoBtnX, savePhotoBtnY, savePhotoBtnW, savePhotoBtnH);
    
    //取消按钮
    NSInteger cancelBtnH = 40;
    NSInteger cancelBtnW = 100;
    NSInteger cancelBtnX = (ScreenWidth - 50 - cancelBtnW);
    NSInteger cancelBtnY = ScreenHeight - 100;
    
    self.cancelBtn.frame = CGRectMake(cancelBtnX, cancelBtnY, cancelBtnW, cancelBtnH);
}

#pragma mark 按钮点击事件
-(void)savePhoto
{
    [self removeFromSuperview];
    
    if([self.delegate respondsToSelector:@selector(HJCameraShowPhotoViewFinish)]){
        [self.delegate HJCameraShowPhotoViewFinish];
    }
}

-(void)cancelSavePhoto
{
    [self removeFromSuperview];
    if([self.delegate respondsToSelector:@selector(HJCameraShowPhotoViewFinish)]){
        [self.delegate HJCameraShowPhotoViewFinish];
    }
}
@end
