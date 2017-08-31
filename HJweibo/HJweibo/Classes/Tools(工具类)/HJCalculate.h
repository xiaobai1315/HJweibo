//
//  HJCalculate.h
//  HJweibo
//
//  Created by Jermy on 2017/6/28.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJCalculate : NSObject

@property(nonatomic, assign)CGFloat sum;    //计算的总和

//加法运算
-(HJCalculate *(^)(CGFloat))add;

@end
