//
//  HJCameraShowPhotoView.h
//  HJweibo
//
//  Created by Jermy on 2017/6/23.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HJCameraShowPhotoViewDelegate <NSObject>

-(void)HJCameraShowPhotoViewFinish;

@end

@interface HJCameraShowPhotoView : UIView

-(instancetype)initWithImage:(UIImage *)image;
+(instancetype)showPhotoViewWithImage:(UIImage *)image;

@property(nonatomic, weak)id<HJCameraShowPhotoViewDelegate> delegate;

@end
