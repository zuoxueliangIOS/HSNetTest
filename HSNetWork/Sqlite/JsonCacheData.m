//
//  JsonCacheData.m
//  SQLite
//
//  Created by 王国栋 on 16/7/1.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import "JsonCacheData.h"

@implementation JsonCacheData
-(BOOL)isExpire
{
    NSTimeInterval timeNow = [[NSDate date]timeIntervalSince1970];
    
    
    NSLog(@"%f %ld",timeNow,(self.saveTime+self.expireTime));
    
    return timeNow > (self.saveTime+self.expireTime);
}

-(instancetype)init
{
    if (self = [super init]) {
        self.saveTime = (int)MAXFLOAT;//先设置为最大
        self.jsonCache =nil;
        self.expireTime = 0;
    }
    return self;
}
-(NSDictionary *)JsonData
{
    
    /*!
     
     * @brief 把格式化的JSON格式的字符串转换成字典
     
     * @param jsonString JSON格式的字符串
     
     * @return 返回字典
     
     */
    
    //json格式字符串转字典：
        if (self.jsonCache == nil) {
            return nil;
        }
        NSData *jsonData = [self.jsonCache dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:kNilOptions
                                                              error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
            return nil;
        }
        return dic;
        
}


@end
