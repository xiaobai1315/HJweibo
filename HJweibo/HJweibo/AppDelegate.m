//
//  AppDelegate.m
//  HJweibo
//
//  Created by Jermy on 17/3/1.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "AppDelegate.h"
#import <WeiboSDK.h>
#import "HJTabBarController.h"
#import "HJAuthViewController.h"
#import "HJAccountModel.h"
#import "HJNewFeatureViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    //取缓存的版本号
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:appVersionKey];
    
    //取出当前版本号
    NSString *currentVersion = [[NSBundle mainBundle] infoDictionary][appVersionKey];
    
    //缓存的版本号和当前版本不同
    if(![version isEqualToString:currentVersion]){
        
        //缓存最新的版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:appVersionKey];
        
        //显示新特性页面
        HJNewFeatureViewController *newFeatureVC = [[HJNewFeatureViewController alloc] init];
        self.window.rootViewController = newFeatureVC;
        
        [self.window makeKeyAndVisible];
        return YES;
    }
    
    //读取缓存数据，判断是否已经授权
    HJAccountModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountCachePath];
    if(account == nil){
        //没有缓存数据，跳转到授权页面
        HJAuthViewController *authVC = [[HJAuthViewController alloc] init];
        self.window.rootViewController = authVC;
    }else{
        //有缓存数据，跳转到主页
        HJTabBarController *tabbarVC = [[HJTabBarController alloc] init];
        self.window.rootViewController = tabbarVC;
    }
    
    //获取官方表情
    [self getEmotions];

    [self.window makeKeyAndVisible];
    return YES;
}

//获取官方表情
-(void)getEmotions
{
    //判断表情文件是否存在，如果存在，返回; 如果不存在 下载表情数据
    if([[NSFileManager defaultManager] fileExistsAtPath:EmotionCachePath]){
        
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    HJAccountModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountCachePath];
    
    NSDictionary *para = @{
                           @"access_token" : account.access_token
                           };
    
        [manager GET:getEmotions parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
            
            //创建emotion缓存文件
            [[NSFileManager defaultManager] createFileAtPath:EmotionCachePath contents:nil attributes:nil];
            
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:responseObject];
            
            //将emotion写入文件
            if(![array writeToFile:EmotionCachePath atomically:YES]){
                
                NSLog(@"写emotion文件失败");
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

-(void)saveEmotionToDB:(NSArray *)emotionArr
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        //将模型数组写入本地数据库
        if([[HJSQLiteManager shareManager] openDBWithPath:EmotionDBPath]){
            
            //创建表
            [[HJSQLiteManager shareManager] execSQL:EmotionSQLcreateTable];
            
            //插入数据
            for(HJEmotionModel *model in emotionArr){
                
                NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO t_emotions (value, url) VALUES ('%@', '%@');", model.value, model.url];
                
                if(![[HJSQLiteManager shareManager] execSQL:insertSQL]){
                    NSLog(@"插入数据失败");
                }
            }
        }
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
