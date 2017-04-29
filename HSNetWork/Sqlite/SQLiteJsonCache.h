//
//  SQLiteJsonCache.h
//  SQLite
//
//  Created by 王国栋 on 16/7/1.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteDB.h"
@interface SQLiteJsonCache : NSObject

/**
 *  插入一个json缓存数据
 *
 *  @param key         键
 *  @param value       数据
 *  @param expire_time 过期时间
 */

+ (void)insertJonsCacheStringWithKey:(NSString *)key andWithValue:(NSString*) value andWithExpireTime:(NSInteger )expire_time;

/**
 *  根据JSON缓存获取一个包含对JSON数据操作的对象
 *
 *  @param key 键
 *
 *  @return --- JsonCacheData类型的可以对提取的json处理
 */
+(JsonCacheData *)queryJsonCacheTableWithKey:(NSString *)key;


/**
 *  插入的值是字典类型
 *
 *  @param key         键
 *  @param value       值
 *  @param expire_time 过期时间
 */
+ (void)insertJsonCacheDictWithKey:(NSString *)key andWithValue:(NSDictionary*) value andWithExpireTime:(NSInteger )expire_time;

/**
 *  删除数据缓存
 *
 *  @param key
 */

+ (BOOL)DeleteJsonCacheDictWithKey:(NSString *)key;

@end
