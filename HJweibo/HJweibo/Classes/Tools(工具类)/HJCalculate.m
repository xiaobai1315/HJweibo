//
//  HJCalculate.m
//  HJweibo
//
//  Created by Jermy on 2017/6/28.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJCalculate.h"

@implementation HJCalculate

-(HJCalculate *(^)(CGFloat))add
{
    return ^HJCalculate *(CGFloat value){
      
        _sum += value;
        
        return self;
    };
}

@end
