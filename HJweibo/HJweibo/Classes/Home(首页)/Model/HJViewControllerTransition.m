//
//  HJViewControllerTransition.m
//  HJweibo
//
//  Created by Jermy on 2017/6/21.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJViewControllerTransition.h"

@interface HJViewControllerTransition()

@property(nonatomic, assign)HJViewControllerTransitionType type;

@end

@implementation HJViewControllerTransition

#pragma mark 初始化方法
-(instancetype)initViewControllerTransitionWithType:(HJViewControllerTransitionType) type
{
    if(self = [super init]){
        
        _type = type;
    }
    
    return self;
}

+(instancetype)ViewControllerTransitionWithType:(HJViewControllerTransitionType) type
{
    return [[self alloc] initViewControllerTransitionWithType:type];
}

#pragma mark UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if(_type == HJViewControllerTransitionTypePresent){
        
        [self presentAnimateTransition:transitionContext];
    }else{
        
        [self dismissAnimateTransition:transitionContext];
    }
}

//弹出的动画
-(void)presentAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //获取presenting和presentedView
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    //获取容器View
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    
    toView.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight);

    //开始动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
        toView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
        
    }];
}

//消失的动画
-(void)dismissAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //获取presenting和presentedView
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    //开始动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromView.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight);
        toView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
    } completion:^(BOOL finished) {
        
        [fromView removeFromSuperview];
        [transitionContext completeTransition:YES];
        
    }];

}
@end
