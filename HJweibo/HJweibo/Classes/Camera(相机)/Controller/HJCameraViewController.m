//
//  HJCameraViewController.m
//  HJweibo
//
//  Created by Jermy on 2017/6/15.
//  Copyright © 2017年 Jermy. All rights reserved.
//  相机

#import "HJCameraViewController.h"
#import "HJCameraSettingTableViewController.h"
#import "HJCameraShowPhotoView.h"

@interface HJCameraViewController ()<HJCameraShowPhotoViewDelegate>

@property(nonatomic, weak)UIImageView *imageView;   //显示拍照的照片

@property(nonatomic, strong)UIButton *settingBtn;   //设置按钮
@property(nonatomic, strong)UIButton *dismissBtn;   //返回按钮
@property(nonatomic, strong)UIButton *photographBtn;//拍照按钮
@property(nonatomic, strong)UIButton *flashBtn;     //设置闪光灯按钮
@property(nonatomic, strong)UIButton *switchCameraBtn;   //切换相机按钮
@property(nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;//相机显示层

@end

@implementation HJCameraViewController
{
    AVCaptureDevice *_device;               //相机设备
    AVCaptureDeviceInput *_input;           //输入设备
    AVCaptureStillImageOutput *_output;     //图片输出设备
    AVCaptureSession *_session;             //将输入、输出设备结合在一起
}

#pragma mark 懒加载
-(UIImageView *)imageView
{
    if(_imageView == nil){
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.view.bounds;
        [self.view addSubview:imageView];
        
        _imageView = imageView;
    }
    
    return _imageView;
}

//隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark 初始化

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
    
    //屏蔽返回手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    //隐藏导航栏
    self.navigationController.navigationBar.hidden = NO;
    
    //屏蔽返回手势
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建相机
    [self setupCamera];
    
    //添加子控件
    [self setupSubView];
}

//创建相机
-(void)setupCamera
{
    //获取后置相机
    _device = [self getCameraWithPosition:AVCaptureDevicePositionBack];
    
    //创建输入设备
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    
    //创建图片输出设备
    _output = [[AVCaptureStillImageOutput alloc] init];
    
    //将输入、输出设备结合在一起
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPreset640x480;
    
    if([_session canAddInput:_input]){
        [_session addInput:_input];
    }
    
    if([_session canAddOutput:_output]){
        [_session addOutput:_output];
    }
    
    //生成预览层
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    previewLayer.frame = self.view.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer = previewLayer;
    [self.view.layer addSublayer:previewLayer];
    
    //开始取景
    [_session startRunning];
    
    //设置闪光灯模式为自动模式
    if([_device lockForConfiguration:nil]){
        
        if([_device isFlashModeSupported:AVCaptureFlashModeAuto]){
            
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
    }
    
    [_device unlockForConfiguration];
}

//获取指定位置的相机
-(AVCaptureDevice *)getCameraWithPosition:(AVCaptureDevicePosition) position
{
    AVCaptureDevice *device = nil;
    
    for (AVCaptureDevice *tempDevice in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]){
        
        if(tempDevice.position == position){
            device = tempDevice;
            break;
        }
    }
    
    return device;
}

//添加子控件
-(void)setupSubView
{
    //设置按钮
    self.settingBtn = [self addButtonWithImage:@"popover_icon_setting"
                                        target:self
                                      selector:@selector(settingBtnClick)];
    self.settingBtn.frame = CGRectMake(0, 0, 50, 50);
    
    //返回按钮
    self.dismissBtn = [self addButtonWithImage:@"alipay_msp_back"
                                        target:self
                                      selector:@selector(dismissBtnClick)];
    self.dismissBtn.frame = CGRectMake(ScreenWidth - 50, 0, 50, 50);
    
    //拍照按钮
    NSInteger photographBtnW = 80;
    NSInteger photographBtnH = 80;
    NSInteger photographBtnX = (ScreenWidth - photographBtnW) * 0.5;
    NSInteger photographBtnY = ScreenHeight - photographBtnH - 50;
    
    self.photographBtn = [self addButtonWithImage:@"camera_video_capture_placeholder"
                                           target:self
                                         selector:@selector(photographBtnClick)];
    self.photographBtn.frame = CGRectMake(photographBtnX, photographBtnY, photographBtnW, photographBtnH);
    
    //设置闪光灯按钮
    NSInteger flashBtnW = 40;
    NSInteger flashBtnH = 40;
    NSInteger flashBtnX = (ScreenWidth * 0.5 - flashBtnW) * 0.5;
    NSInteger flashBtnY = self.photographBtn.center.y - flashBtnH * 0.5;
    
    self.flashBtn = [self addButtonWithImage:@"YXCapturePhotoSwitchFlashBtnOn"
                                      target:self
                                    selector:@selector(flashBtnClick)];
    self.flashBtn.frame = CGRectMake(flashBtnX, flashBtnY, flashBtnW, flashBtnH);
    
    //切换相机按钮
    NSInteger switchCameraBtnW = 40;
    NSInteger switchCameraBtnH = 40;
    NSInteger switchCameraBtnX = ScreenWidth * 0.5 + (ScreenWidth * 0.5 - flashBtnW) * 0.5;
    NSInteger switchCameraBtnY = self.photographBtn.center.y - flashBtnH * 0.5;
    
    self.switchCameraBtn = [self addButtonWithImage:@"YXCapturePhotoSwitchCameraBtn"
                                             target:self
                                           selector:@selector(switchCameraBtnClick)];
    self.switchCameraBtn.frame = CGRectMake(switchCameraBtnX, switchCameraBtnY, switchCameraBtnW, switchCameraBtnH);
}

//创建按钮
-(UIButton *)addButtonWithImage:(NSString *)image target:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    return button;
}

#pragma mark 按钮点击事件
//设置按钮点击事件
-(void)settingBtnClick
{
    HJCameraSettingTableViewController *settingVC = [[HJCameraSettingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:settingVC];
    
    [self presentViewController:navi animated:YES completion:nil];
}

//返回按钮点击事件
-(void)dismissBtnClick
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//拍照按钮点击事件
-(void)photographBtnClick
{
    AVCaptureConnection *connection = [_output connectionWithMediaType:AVMediaTypeVideo];
    if(!connection){
        HJLog(@"拍照失败");
        return;
    }
    
    //获取图片
    [_output captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *image = [UIImage imageWithData:imageData];
        
//        self.imageView.image = image;
//        [self.view addSubview:self.imageView];
        
        HJCameraShowPhotoView *showPhotoView = [HJCameraShowPhotoView showPhotoViewWithImage:image];
        showPhotoView.delegate = self;
        [self.view addSubview:showPhotoView];
        [self.view bringSubviewToFront:showPhotoView];
        
        [_session stopRunning];
    }];
}

//闪光灯按钮点击事件
-(void)flashBtnClick
{
    //闪光灯默认为自动模式，点击后切换到关闭模式，再次点击切换到开启模式，再次点击，切换到自动模式
    if([_device lockForConfiguration:nil]){
        
        //开启模式->自动模式
        if(_device.flashMode == AVCaptureFlashModeOn){
            
            if([_device isFlashModeSupported:AVCaptureFlashModeAuto]){
                
                [_device setFlashMode:AVCaptureFlashModeAuto];
                [self.flashBtn setImage:[UIImage imageNamed:@"YXCapturePhotoSwitchFlashBtnOn"] forState:UIControlStateNormal];
            }
        }else if(_device.flashMode == AVCaptureFlashModeAuto){
            
            //自动 -> 关闭
            if([_device isFlashModeSupported:AVCaptureFlashModeOff]){
                
                [_device setFlashMode:AVCaptureFlashModeOff];
                [self.flashBtn setImage:[UIImage imageNamed:@"YXCapturePhotoSwitchFlashBtnOff"] forState:UIControlStateNormal];
            }

        }else if([_device isFlashModeSupported:AVCaptureFlashModeOff]){
            //关闭 -> 开启
            if([_device isFlashModeSupported:AVCaptureFlashModeOn]){
                
                [_device setFlashMode:AVCaptureFlashModeOn];
                [self.flashBtn setImage:[UIImage imageNamed:@"YXCapturePhotoSwitchFlashBtn"] forState:UIControlStateNormal];
            }
        }
    }
}

//切换摄像头按钮点击事件
-(void)switchCameraBtnClick
{
    //获取手机相机的个数
    NSInteger cameraCount = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count;
    
    if(cameraCount > 1){
        
        //相机切换的动画
        CATransition *transition = [CATransition animation];
        transition.type = @"oglFlip";
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        
        //获取新相机
        AVCaptureDevice *newDeivce = nil;
        if(_device.position == AVCaptureDevicePositionFront){
            
            newDeivce = [self getCameraWithPosition:AVCaptureDevicePositionBack];
            transition.subtype = kCATransitionFromLeft;
        }else{
            
            newDeivce = [self getCameraWithPosition:AVCaptureDevicePositionFront];
            transition.subtype = kCATransitionFromRight;
        }
        
        //创建新的输入
        AVCaptureDeviceInput *newInput = [[AVCaptureDeviceInput alloc] initWithDevice:newDeivce error:nil];
        [self.previewLayer addAnimation:transition forKey:nil];
        if(newInput != nil){
            
            [_session beginConfiguration];
            [_session removeInput:_input];

            if([_session canAddInput:newInput]){
                [_session addInput:newInput];
                _input = newInput;
                _device = newDeivce;
            }else{
                [_session removeInput:_input];
            }
            
            [_session commitConfiguration];
        }
    }
}

#pragma mark HJCameraShowPhotoViewDelegate
//保存或者取消的回调
-(void)HJCameraShowPhotoViewFinish
{
    //相机重新取景
    [_session startRunning];
}

@end
