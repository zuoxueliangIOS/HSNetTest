//
//  SqliteDB.h
//  SQLite
//
//  Created by 王国栋 on 16/6/30.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonCacheData.h"
#import "JSONKit.h"

typedef enum
{
    SQLiteTableTypeDraft,
    SQLiteTableTypeJSONCache,
}SQLiteTableType;

@interface SqliteDB : NSObject

//-----------草稿

+(NSString *)queryDraftTableWithKey:(NSString *)key;//查询草稿的数据

+ (void)insertDraftTableWithKey:(NSString *)key andWithValue:(NSString*)value;

//字典
+(void)insertDraftTableWithKey:(NSString *)key andWithDictValue:(NSDictionary*)value;

+(NSDictionary *)queryDraftDictTableWithKey:(NSString *)key;//查询草稿的数据

//数组
+(void)insertDraftTableWithKey:(NSString *)key andWithArrayValue:(NSArray*)value;

+(NSArray *)queryDraftArrayTableWithKey:(NSString *)key;//查询草稿的数据



// ------ 网络缓存的


/**
 *  返回一个JSON缓存的对象
 
 */
+(JsonCacheData *)queryJsonCacheTableWithKey:(NSString *)key;

+(void) insertJsonCacheWithKey:(NSString *)key andWithValue:(NSString*)value andWithExpiretime:(NSInteger) expireTime;

+(void)insertDictJsonCacheWithKey:(NSString *)key andWithValue:(NSDictionary*)dictValue andWithExpiretime:(NSInteger) expireTime;

+(BOOL)deleteDictJsonCacheWithKey:(NSString *)key;

//------推送缓存的

+(void)insertPushCacheWithKey:(NSString *)key andWithValue:(NSDictionary*)value;

+(NSDictionary*)queryPushCacheWithKey:(NSString*)key;

+(NSArray *)queryPushPageCnt:(int)count Page:(int) page;

@end
