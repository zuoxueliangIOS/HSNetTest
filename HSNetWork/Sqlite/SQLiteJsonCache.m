//
//  SQLiteJsonCache.m
//  SQLite
//
//  Created by 王国栋 on 16/7/1.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import "SQLiteJsonCache.h"

@implementation SQLiteJsonCache


+ (void)insertJonsCacheStringWithKey:(NSString *)key andWithValue:(NSString*) value andWithExpireTime:(NSInteger )expire_time
{

    [SqliteDB insertJsonCacheWithKey:key andWithValue:value andWithExpiretime:expire_time];
}

+(JsonCacheData *)queryJsonCacheTableWithKey:(NSString *)key
{
    return [SqliteDB queryJsonCacheTableWithKey:key];
}

+ (void)insertJsonCacheDictWithKey:(NSString *)key andWithValue:(NSDictionary*) value andWithExpireTime:(NSInteger )expire_time
{

    [SqliteDB insertDictJsonCacheWithKey:key andWithValue:value andWithExpiretime:expire_time];
}
+ (BOOL)DeleteJsonCacheDictWithKey:(NSString *)key{

    return [SqliteDB deleteDictJsonCacheWithKey:key];
}

@end
