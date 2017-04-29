//
//  SQLiteDraft.h
//  SQLite
//
//  Created by 王国栋 on 16/7/1.
//  Copyright © 2016年 xiaobai. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SqliteDB.h"
#import "SQLiteJsonCache.h"

@interface SQLiteDraft : NSObject

//查询草稿的数据
+(NSString *)queryDraft:(NSString *)key;

//插入草稿数据
+ (void)insertDraftWithKey:(NSString *)key andWithValue:(NSString*)value;

//----字典
//查询草稿的数据
+(NSDictionary *)queryDraftDict:(NSString *)key;

//插入草稿数据
+ (void)insertDraftWithKey:(NSString *)key andWithDictValue:(NSDictionary*)value;

//---
//数组
+(void)insertDraftTableWithKey:(NSString *)key andWithArrayValue:(NSArray*)value;

+(NSArray *)queryDraftArrayTableWithKey:(NSString *)key;//查询草稿的数据


@end
