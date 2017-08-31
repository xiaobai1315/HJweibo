//
//  HJTabBarController.m
//  HJweibo
//
//  Created by Jermy on 2017/6/9.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJTabBarController.h"
#import "HJHomeTableViewController.h"
#import "HJDiscoverTableViewController.h"
#import "HJMessageTableViewController.h"
#import "HJMeTableViewController.h"
#import "HJTabBar.h"
#import "HJVisualEffectView.h"

@interface HJTabBarController ()<HJTabBarDelegate>

@end

@implementation HJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    //添加子控制器
    [self addViewControllers];
    
    //自定义tabbar
    HJTabBar *hjTabbar = [[HJTabBar alloc] init];
    hjTabbar.myDelegate = self;
    [self setValue:hjTabbar forKey:@"tabBar"];
    
}

//添加子控制器
-(void)addViewControllers
{
    //首页
    [self setupController:[[UINavigationController alloc] initWithRootViewController:[[HJHomeTableViewController alloc] init]] Title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    //发现
    [self setupController:[[UINavigationController alloc] initWithRootViewController:[[HJDiscoverTableViewController alloc] init]] Title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    //消息
    [self setupController:[[UINavigationController alloc] initWithRootViewController:[[HJMessageTableViewController alloc] init]] Title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];

    //我
    [self setupController:[[UINavigationController alloc] initWithRootViewController:[[HJMeTableViewController alloc] init]] Title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
}

//创建子控制器
-(void)setupController:(UIViewController *)viewController
                 Title:(NSString *)title
                 image:(NSString *)image
         selectedImage:(NSString *)selectedImage
{
    [viewController.tabBarItem setTitle:title];
    //设置标题文字的属性
    NSDictionary *attr = @{NSForegroundColorAttributeName : [UIColor blackColor],
                           NSFontAttributeName : [UIFont systemFontOfSize:13]};
    
    [viewController.tabBarItem setTitleTextAttributes:attr forState:UIControlStateNormal];
    [viewController.tabBarItem setTitleTextAttributes:attr forState:UIControlStateSelected];
    [viewController.tabBarItem setImage:[UIImage imageNamed:image]];
    [viewController.tabBarItem setSelectedImage:[UIImage imageNamed:selectedImage]];
    [self addChildViewController:viewController];
}

#pragma mark 添加按钮点击事件
-(void)HJTabBarAddBtnClick
{
    HJVisualEffectView *visualEffectView = [[HJVisualEffectView alloc] init];
    visualEffectView.frame = self.view.bounds;
    [self.view addSubview:visualEffectView];
}

@end
