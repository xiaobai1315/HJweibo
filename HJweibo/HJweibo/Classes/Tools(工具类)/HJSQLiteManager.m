//
//  HJSQLiteManager.m
//  HJweibo
//
//  Created by Jermy on 2017/7/5.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJSQLiteManager.h"
#import <sqlite3.h>

@interface HJSQLiteManager()

@property(nonatomic, assign)sqlite3 *ppDb;

@end

@implementation HJSQLiteManager

#pragma mark 单例
static HJSQLiteManager *manager;
+(instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
    });
    
    return manager;
}

//打开数据库
- (BOOL)openDBWithPath:(NSString *)DBPath
{
    //打开、创建数据库，
    if(sqlite3_open([DBPath UTF8String], &_ppDb) != SQLITE_OK){
        
        NSLog(@"创建数据库失败");
        return NO;
    };
    
    return YES;
}


//执行SQL
- (BOOL)execSQL:(NSString *)sql
{
    int res = sqlite3_exec(_ppDb, [sql UTF8String], nil, nil, nil);
    
    return (res == SQLITE_OK);
    
}

//查询数据
- (NSArray *)querySQL:(NSString *)querySQL
{
    // 定义游标对象
    sqlite3_stmt *stmt = nil;
    
    // 准备查询
    // 1> 参数一:数据库对象
    // 2> 参数二:查询语句
    // 3> 参数三:查询语句的长度:-1
    // 4> 参数四:句柄(游标对象)
    if (sqlite3_prepare_v2(_ppDb, querySQL.UTF8String, -1, &stmt, nil) != SQLITE_OK) {
        NSLog(@"准备查询失败");
        return nil;
    };
    
    // 准备成功,开始查询数据
    NSMutableArray *dictArray = [NSMutableArray array];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        // 获取一共多少列
        int count = sqlite3_column_count(stmt);
        
        // 定义字典
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (int i = 0; i < count; i++) {
            // 取出i位置列的字段名,作为字典的键
            const char *cKey = sqlite3_column_name(stmt, i);
            NSString *key = [NSString stringWithUTF8String:cKey];
            
            // 取出i位置的存储的值,作为字典的值
            const char *cValue = (const char *)sqlite3_column_text(stmt, i);
            NSString *value = [NSString stringWithUTF8String:cValue];
            
            // 将键值对一个一个放入字典中
            [dict setValue:value forKey:key];
        }
        
        // 将获取的字典放入数组中
        [dictArray addObject:dict];
    }
    
    // 返回取出所有数据的数组
    return dictArray;
}


@end
