//
//  SqlitePush.m
//  hskaoyan
//
//  Created by 王国栋 on 16/9/7.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "SqlitePush.h"

@implementation SqlitePush
+(void)insertPushCacheWithKey:(NSString *)key andWithValue:(NSDictionary*)value
{
    if ([key length]==0) {
        NSTimeInterval writeDate = [[NSDate date] timeIntervalSince1970];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:writeDate];
        NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];

        
        
        key = [NSString stringWithFormat:@"%lf",writeDate];
    }
    [SqliteDB insertPushCacheWithKey:key andWithValue:value];
}

+(NSDictionary*)queryPushCacheWithKey:(NSString*)key
{
    return [SqliteDB queryPushCacheWithKey:key];
}
+(NSArray *)queryPushPageCnt:(int)count Page:(int) page
{
    return [SqliteDB queryPushPageCnt:count Page:page];
}

@end
