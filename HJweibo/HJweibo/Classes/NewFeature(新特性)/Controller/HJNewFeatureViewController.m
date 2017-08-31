//
//  HJNewFeatureViewController.m
//  HJweibo
//
//  Created by Jermy on 2017/6/14.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJNewFeatureViewController.h"
#import "HJAccountModel.h"
#import "HJAuthViewController.h"
#import "HJTabBarController.h"

@interface HJNewFeatureViewController ()

@end

@implementation HJNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//进入微博
- (IBAction)enterWeibo:(id)sender {
    
    //读取缓存数据，判断是否已经授权
    HJAccountModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountCachePath];
    if(account == nil){
        //没有缓存数据，跳转到授权页面
        HJAuthViewController *authVC = [[HJAuthViewController alloc] init];
        [self presentViewController:authVC animated:YES completion:nil];
    }else{
        //有缓存数据，跳转到主页
        HJTabBarController *tabbarVC = [[HJTabBarController alloc] init];
        [self presentViewController:tabbarVC animated:YES completion:nil];
    }
    
}

@end
