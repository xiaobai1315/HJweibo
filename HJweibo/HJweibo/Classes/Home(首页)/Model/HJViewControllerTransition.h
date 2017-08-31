//
//  HJViewControllerTransition.h
//  HJweibo
//
//  Created by Jermy on 2017/6/21.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//转场动画的类型
typedef NS_ENUM(NSInteger, HJViewControllerTransitionType){
    
    HJViewControllerTransitionTypePresent = 0,
    HJViewControllerTransitionTypeDismiss
};

@interface HJViewControllerTransition : NSObject<UIViewControllerAnimatedTransitioning>

-(instancetype)initViewControllerTransitionWithType:(HJViewControllerTransitionType) type;
+(instancetype)ViewControllerTransitionWithType:(HJViewControllerTransitionType) type;
@end
