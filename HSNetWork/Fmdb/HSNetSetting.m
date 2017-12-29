//
//  HSNetSetting.m
//  hskaoyan
//
//  Created by 王国栋 on 16/8/10.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//


#import "HSNetSetting.h"


//请求方式的键
@interface HSNetSetting ()

@end

@implementation HSNetSetting
+(instancetype)noSaveCacheSet//不写缓存
{
    HSNetSetting * set = [[HSNetSetting alloc]init];
    set.isEncry = YES;
    set.isCtrlHub = NO;
    set.askMethod = NetMethodPOST;
    set.cachePolicy = HSCacheNoSave;
    return set;
}
+(instancetype)noReadCacheSet//不读缓存
{
    HSNetSetting * set = [[HSNetSetting alloc]init];
    set.isEncry = YES;
    set.isCtrlHub = NO;
    set.askMethod = NetMethodPOST;
    set.cachePolicy = HSCacheNoRead;
    return set;
}
//和默认的一样
+(instancetype)readCacheSet{
    HSNetSetting * set = [[HSNetSetting alloc]init];
    set.isEncry = YES;
    set.isCtrlHub = NO;
    set.askMethod = NetMethodPOST;
    set.cachePolicy = HSCacheNormal;
    return set;
}//读缓存
+(instancetype)noEncryPost
{
    HSNetSetting * set = [[HSNetSetting alloc]init];
    set.isEncry = NO;
    set.isCtrlHub = NO;
    set.askMethod = NetMethodPOST;
    set.cachePolicy = HSCacheNoSave;
    return set;
}
@end
