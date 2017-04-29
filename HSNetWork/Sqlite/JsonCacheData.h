//
//  JsonCacheData.h
//  SQLite
//
//  Created by 王国栋 on 16/7/1.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonCacheData : NSObject

/**
 *  json缓存的数据类型
 */


//存入的时间
@property (nonatomic,assign) NSInteger saveTime;
//过期的时间长度
@property (nonatomic,assign) NSInteger expireTime;
//从数据库返回的字符串信息
@property (nonatomic,strong) NSString * jsonCache;

//这里定义了一些方法，返回不同类型的jsondict

//是否过期
/**
 是否过期
 */
-(BOOL)isExpire;
/**
 *  转换成JSON类型
 *
 *  @return JSON数据的字典
 */
-(NSDictionary *)JsonData;


@end
