//
//  SqlitePush.h
//  hskaoyan
//
//  Created by 王国栋 on 16/9/7.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteDB.h"
@interface SqlitePush : NSObject


+(void)insertPushCacheWithKey:(NSString *)key andWithValue:(NSDictionary*)value;

+(NSDictionary*)queryPushCacheWithKey:(NSString*)key;

+(NSArray *)queryPushPageCnt:(int)count Page:(int) page;
@end
