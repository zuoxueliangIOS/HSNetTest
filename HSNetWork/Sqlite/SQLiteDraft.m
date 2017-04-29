//
//  SQLiteDraft.m
//  SQLite
//
//  Created by 王国栋 on 16/7/1.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import "SQLiteDraft.h"
@implementation SQLiteDraft

//查询草稿的数据
+(NSString *)queryDraft:(NSString *)key
{
    return  [SqliteDB queryDraftTableWithKey:key];
}

//插入草稿数据
+ (void)insertDraftWithKey:(NSString *)key andWithValue:(NSString*)value
{
    
    [SqliteDB insertDraftTableWithKey:key andWithValue:value];
    //[SqliteDB insertTable:SQLiteTableTypeJSONCache andWithKey:key andWithValue:value];
}

+(NSDictionary *)queryDraftDict:(NSString *)key
{
    return [SqliteDB queryDraftDictTableWithKey:key];
}
//插入草稿数据
+ (void)insertDraftWithKey:(NSString *)key andWithDictValue:(NSDictionary*)value
{
    [SqliteDB insertDraftTableWithKey:key andWithDictValue:value];
}
//数组
+(void)insertDraftTableWithKey:(NSString *)key andWithArrayValue:(NSArray*)value
{
    [SqliteDB insertDraftTableWithKey:key andWithArrayValue:value];
}

+(NSArray *)queryDraftArrayTableWithKey:(NSString *)key//查询草稿的数据
{
    return [SqliteDB queryDraftArrayTableWithKey:key];
}




@end
