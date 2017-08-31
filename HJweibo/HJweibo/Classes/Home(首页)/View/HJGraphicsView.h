//
//  HJGraphicsView.h
//  HJweibo
//
//  Created by Jermy on 2017/6/28.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HJStatus;

@interface HJGraphicsView : UIView

@property(nonatomic, strong)HJStatus *status;

@property(nonatomic, assign)BOOL isRetweet; //是否是转发的微博

@end
