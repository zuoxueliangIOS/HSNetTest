//
//  AFNetworkTool.h
//  AFNetText2.5
//
//  Created by wxxu on 15/1/27.
//  Copyright (c) 2015年 wxxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "HSNetSetting.h"
#import <CommonCrypto/CommonDigest.h>
//#import "MacroDefinition.h"

@interface AFNetworkTool : NSObject




//------统一配置的网络方法

+(void)HVDataCache:(NSDictionary *) param NetBlock:(void (^)(NSDictionary *json))success ErrorCode :(void(^)(int errorCode))codeError Fail:(void(^)())fail Setting:(HSNetSetting*)netSettting;


@end






