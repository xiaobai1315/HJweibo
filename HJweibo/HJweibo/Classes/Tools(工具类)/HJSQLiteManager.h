//
//  HJSQLiteManager.h
//  HJweibo
//
//  Created by Jermy on 2017/7/5.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJSQLiteManager : NSObject

+(instancetype)shareManager;

- (BOOL)openDBWithPath:(NSString *)DBPath;

- (BOOL)execSQL:(NSString *)sql;

- (NSArray *)querySQL:(NSString *)querySQL;

@end
