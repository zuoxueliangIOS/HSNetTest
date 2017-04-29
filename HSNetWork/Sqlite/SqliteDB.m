//
//  SqliteDB.m
//  SQLite
//
//  Created by 王国栋 on 16/6/30.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import "SqliteDB.h"
#import "FMDB.h"
#import "EncryProcess.h"

static SqliteDB * _onlyOne;

//这里是带字符串的宏定义拼接
#define share(Name)  share##Name
//宏定义类方法
#define shareM(Name) \
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
\
_onlyOne = [[SqliteDB alloc]init];\
});\
return _onlyOne;\
}\
\
+(instancetype)share##Name\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
\
_onlyOne = [[SqliteDB alloc]init];\
});\
return _onlyOne;\
}\
\
- (id)copyWithZone:(NSZone *)zone\
{\
return _onlyOne;\
}
//最后一个括号不加


static FMDatabaseQueue *queue;


@interface SqliteDB ()

@end

@implementation SqliteDB


/**
 *  
 //字典
 +(void)insertDraftTableWithKey:(NSString *)key andWithDictValue:(NSDictionary*)value;
 
 +(NSDictionary *)queryDraftDictTableWithKey:(NSString *)key;//查询草稿的数据
 
 //数组
 +(void)insertDraftTableWithKey:(NSString *)key andWithArrayValue:(NSArray*)value;
 
 +(NSArray *)queryDraftArrayTableWithKey:(NSString *)key;//查询草稿的数据

 */
+ (void)initialize
{
    // 0.获得沙盒中的数据库文件名
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"hsky2"];
        // 1.创建数据库队列
        queue = [FMDatabaseQueue databaseQueueWithPath:filename];
        // 2.创表
        [queue inDatabase:^(FMDatabase *db) {
            //创建表1
            BOOL result = [db executeUpdate:@"create table if not exists t_jsoncache (id integer primary key autoincrement,key text unique, content blob, write_date text,expire_time text);"];//存入时间,过期时间
            //创建表2
            BOOL result2 = [db executeUpdate:@"create table if not exists t_draft (id integer primary key autoincrement,key text unique, content text);"];//草稿没有过期时间和存入时间
            BOOL result3 =  [db executeUpdate:@"create table if not exists t_pushcache (id integer primary key autoincrement,push_time text unique,new_user_id text, content text);"];//推送缓存表
            if (result&&result2&&result3) {
                NSLog(@"创建表成功");
            } else {
                NSLog(@"创表失败");
            }
        }];
}

//这里是查询草稿表字符串
+(NSString *)queryDraftTableWithKey:(NSString *)key {
    
    __block NSString * content=nil;
    [queue inDatabase:^(FMDatabase *db) {

        FMResultSet *rs = [db executeQuery:@"SELECT * FROM t_draft where key = ?",key];
        // 2.遍历结果集
        while (rs.next) {
            content = [rs stringForColumn:@"content"];
            break;
        }
        [rs close];
    }];
    return content;
}

//保存草稿字符串
+ (void)insertDraftTableWithKey:(NSString *)key andWithValue:(NSString*)value
{
    NSString * tableName = @"t_draft";
    
    if (value==nil||value.length==0) {
        [queue inDatabase:^(FMDatabase *db) {

            BOOL res =  [db executeUpdate:@"delete from t_draft where key = ?" withArgumentsInArray:@[key]];
            if (res) {
                NSLog(@"删除数据成功");
            }
            else
            {
                NSLog(@"删除数据失败");
            }
        }];
    }
    else
    {
        [queue inDatabase:^(FMDatabase *db) {
            
            NSString * sql = [NSString stringWithFormat:
                              @"SELECT * FROM '%@' where key = ?",tableName];
            FMResultSet * rs = [db executeQuery:sql withArgumentsInArray:@[key]];
            if (rs.next) {//已经存在
                [rs close];
                sql =[NSString stringWithFormat:
                      @"UPDATE '%@' SET content = ?  WHERE key = ?",
                      tableName]; //更新数据库
                [db executeUpdate:sql withArgumentsInArray:@[value,key]];
            }
            else
            {
                sql = [NSString stringWithFormat:@"INSERT INTO '%@' (key, content) VALUES (?, ?)",tableName];
                //更新数据库
                [db executeUpdate:sql withArgumentsInArray:@[key,value]];
            }
        }];
    }
}

//保存草稿字典
+(void)insertDraftTableWithKey:(NSString *)key andWithDictValue:(NSDictionary*)value
{
    NSString * str = [SqliteDB dictionaryToJson:value];
    [SqliteDB insertDraftTableWithKey:key andWithValue:str];
}
 +(NSDictionary *)queryDraftDictTableWithKey:(NSString *)key//查询草稿的数据
{
    __block NSString * content=nil;
    __block NSDictionary * dict;
    [queue inDatabase:^(FMDatabase *db) {
        // 1.查询数据
        FMResultSet *rs = [db executeQuery: @"SELECT * FROM t_draft where key = ?",key];
        // 2.遍历结果集
        while (rs.next) {
            content = [rs stringForColumn:@"content"];
            dict = (NSDictionary*)[content objectFromJSONString];
            break;
        }
        [rs close];
    }];
    return dict;
}
//保存草稿数组
+(void)insertDraftTableWithKey:(NSString *)key andWithArrayValue:(NSArray*)value
{
    NSString * str = [SqliteDB ArrToJson:value];
    [SqliteDB insertDraftTableWithKey:key andWithValue:str];
}

+(NSArray *)queryDraftArrayTableWithKey:(NSString *)key
{
    __block NSString * content=nil;
    __block NSArray * arr;
    [queue inDatabase:^(FMDatabase *db) {
        // 1.查询数据
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM t_draft where key = ?",key];
        // 2.遍历结果集
        while (rs.next) {
            content = [rs stringForColumn:@"content"];
            arr = (NSArray*)[content objectFromJSONString];
            break;
        }
        [rs close];
    }];
    return arr;

}


//----保存来自服务器的数据
+(void) insertJsonCacheWithKey:(NSString *)key andWithValue:(NSString*)value andWithExpiretime:(NSInteger) expireTime
{

  //  value = [EncryProcess textEncrypt:value];//加密
    NSString * tableName = @"t_jsoncache";
    NSInteger writeDate = (long)[[NSDate date] timeIntervalSince1970];

    if (value==nil || value.length==0) {
        
        [queue inDatabase:^(FMDatabase *db) {
            
         BOOL rest = [db executeUpdate:@"DELETE from t_jsoncache where key = ?",key];
        
            if (rest) {
                NSLog(@"删除成功");
            }
            else
            {
                NSLog(@"删除失败");
            }
        }];
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
            
            NSString * sql = [NSString stringWithFormat:
                              @"SELECT * FROM '%@' where key = '%@'",tableName,key];
            FMResultSet * rs = [db executeQuery:sql];
            if (rs.next) {//已经存在
                [rs close];
                
                //update 表名 set  name=?,password=?.... where id=?

                sql = [NSString stringWithFormat:@"UPDATE '%@' SET content = ?,write_date = ?,expire_time = ? where key = ?",tableName];
             BOOL rest =   [db executeUpdate:sql withArgumentsInArray:@[value,[NSNumber numberWithInteger:writeDate],[NSNumber numberWithInteger:expireTime],key]];
                if (rest) {
                    NSLog(@"更新成功");
                }
                else
                {
                    NSLog(@"更新失败");
                }

            }
            else
            {
                sql = [NSString stringWithFormat:@"INSERT INTO '%@' (key, content,write_date,expire_time) VALUES (?,?,?,?)",tableName];
             BOOL rest = [db executeUpdate:sql withArgumentsInArray:@[key,value,[NSNumber numberWithInteger:writeDate],[NSNumber numberWithInteger:expireTime]]];
                if (rest) {
                    NSLog(@"插入成功");
                }
                else
                {
                    NSLog(@"插入失败");
                }

            }
        }];
}



/**
 *  返回一个JSON缓存的对象
 */
+(JsonCacheData *)queryJsonCacheTableWithKey:(NSString *)key
{
    __block JsonCacheData * jcDate= [[JsonCacheData alloc]init];
    [queue inDatabase:^(FMDatabase *db) {
       
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM t_jsoncache where key = ?",key];
        
        jcDate= [[JsonCacheData alloc]init];
        // 2.遍历结果集
        while (rs.next) {
            
            //NSLog(@"-----%@ %ld %ld", [rs stringForColumn:@"content"],[rs longForColumn:@"expire_time"],[rs longForColumn:@"write_date"]);
            jcDate.jsonCache = [rs stringForColumn:@"content"];//[EncryProcess textEncrypt:[rs stringForColumn:@"content"]];
            jcDate.expireTime = [rs longForColumn:@"expire_time"];
            jcDate.saveTime = [rs longForColumn:@"write_date"];
            
           // NSLog(@"%@",jcDate);
            break;
        }
        [rs close];
    }];
    return jcDate;
}
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    if (dic==nil) {
        return nil;
    }
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+ (NSString*)ArrToJson:(NSArray *)arr
{
    if (arr==nil) {
        return nil;
    }
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+(void)insertDictJsonCacheWithKey:(NSString *)key andWithValue:(NSDictionary*)dictValue andWithExpiretime:(NSInteger) expireTime
{
    NSString * str = [SqliteDB dictionaryToJson:dictValue];
    [SqliteDB insertJsonCacheWithKey:key andWithValue:str andWithExpiretime:expireTime];
}
+(BOOL)deleteDictJsonCacheWithKey:(NSString *)key{
     NSString * tableName = @"t_jsoncache";
    __block BOOL re = YES;
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString * sql = [NSString stringWithFormat:@"drop table '%@'",tableName];
          re = [db executeUpdate:sql];
        if(re) {
            re = NO;
            re = [db executeUpdate:@"create table if not exists t_jsoncache (id integer primary key autoincrement,key text unique, content blob, write_date text,expire_time text);"];
        }
    }];
    return re;
}


//-------------------------网络推送的缓存

+(void)insertPushCacheWithKey:(NSString *)key andWithValue:(NSDictionary*)value
{
//    NSString * tableName = @"t_pushcache";
    
    
    

    NSString * user_id = HVUSER_KEY;
    if ([user_id isEqual:[NSNull null]]||[user_id length]==0) {
        user_id = @"default";
    }
    
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet * rs = [db executeQuery:@"SELECT * FROM t_pushcache where push_time = ?",key];
        if (rs.next) {//已经存在
            [rs close];

            [db executeUpdate:@"UPDATE t_pushcache SET content = ?,new_user_id = ? WHERE push_time = ?",[SqliteDB dictionaryToJson:value],user_id,key];
        }
        else
        {
            //更新数据库
            [db executeUpdate:@"INSERT INTO t_pushcache (push_time, content,new_user_id) VALUES (?, ? ,?)",key,[SqliteDB dictionaryToJson:value],user_id];
        }
    }];

}


+(NSDictionary*)queryPushCacheWithKey:(NSString*)key
{
    __block NSString * content=nil;
    __block NSDictionary * dict;
    [queue inDatabase:^(FMDatabase *db) {
        // 1.查询数据
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM t_pushcache where key = ?",key];
        // 2.遍历结果集
        while (rs.next) {
            content = [rs stringForColumn:@"content"];
            dict = (NSDictionary*)[content objectFromJSONString];
            break;
        }
        [rs close];
    }];
    return dict;
}
+(NSArray *)queryPushPageCnt:(int)count Page:(int) page
{
    __block NSMutableArray * arr = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString * user_id =   HVUSER_KEY;
        if ([user_id isEqual:[NSNull null]]||[user_id length]==0) {
            
            user_id = @"default";
        }
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM t_pushcache WHERE new_user_id ='%@' or new_user_id = 'default' order by id desc limit '%d','%d'",user_id,(page-1)*count,count];
        FMResultSet *rs = [db executeQuery:sql];
        while (rs.next) {

            NSString * content =[rs stringForColumn:@"content"];
            NSMutableDictionary * mutableDict = [[NSMutableDictionary alloc]initWithDictionary:[content objectFromJSONString]];
            mutableDict[@"push_time"] = [rs stringForColumn:@"push_time"];
            mutableDict[@"new_user_id"] = [rs stringForColumn:@"new_user_id"];
            
            [arr addObject:mutableDict];

        }
        [rs close];
    }];
    return arr;
}
@end

