//
//  HSNetSetting.h
//  hskaoyan
//
//  Created by 王国栋 on 16/8/10.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络请求的一些配置信息
 */
typedef NS_ENUM(int, HSCacheTime) {
    
    HSCacheNoRead = 0,
    HSCacheNoSave = -1,
    HSCacheNormal = 5,
};
typedef enum
{
    NetMethodPOST = 0,
    NetMethodGET = 1,
}NetMethod;
@interface HSNetSetting : NSObject
//加载动画控制方式，yes表示由调用的控制器控制，NO表示有AFNetWork类控制
@property (nonatomic,assign) BOOL isCtrlHub;
//缓存的策略
@property (nonatomic,assign) HSCacheTime cachePolicy;
//是否加密
@property (nonatomic,assign) BOOL isEncry;
//获取数据的方式，get请求或者post请求
@property (nonatomic,assign) NetMethod askMethod;
//默认的设置
+(instancetype)noSaveCacheSet;//不写缓存
+(instancetype)noReadCacheSet;//不读缓存
+(instancetype)readCacheSet;//读缓存
+(instancetype)noEncryPost;

@end
