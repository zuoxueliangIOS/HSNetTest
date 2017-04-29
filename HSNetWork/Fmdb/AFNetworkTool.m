//
//  AFNetworkTool.m
//  AFNetText2.5
//
//  Created by wxxu on 15/1/27.
//  Copyright (c) 2015年 wxxu. All rights reserved.
//

#import "AFNetworkTool.h"
#import "SVProgressHUD.h"
#import "SQLiteDraft.h"
#import "SQLiteJsonCache.h"
#import "JsonCacheData.h"
#import "AFNetworkTool.h"
#import "HSTabbarViewController.h"
#import "HSNavigationViewController.h"
#import "HSLoginController.h"
//#import "FLLoginViewController.h"
//#import "APIConfig.h"
#import "HSNetSetting.h"
#import "AFHTTPSessionManager.h"

//------网络状态码
#define NetCode_NETWORK_SUCCESS 0
#define NetCode_COMMON_ERRPOR 1
#define NetCode_TOKEN_EXPIRE_ERROR 2
#define NetCode_IMAGE_CODE_ERROR 3
#define NetCode_VERSION_TOO_LOW 4
#define NetCode_RESULT_NEWEST 5


@implementation AFNetworkTool


//-------------------------------------网络方法的配置升级

/**
 *  最新的网络请求方法
 *  @param paramDict 一个字典，包含了上传的参数和路径的URL后缀。ios/"material_list.php?"
 这个参数是双引号的部分，包括问号。前面的不写。存放在字典中，对应的键是 HSOBJ_URL，这是一个宏定义，不是"HSOBJ_URL"字符串，直接写就写
 
 *  @param success   服务器返回了正常的数据
 *  @param codeError 服务器没有返回正常数据，包含了许多错误编码，在这里可以处理，其中一部分都在请求类里面处理了，不用处理
 *  @param fail      网络失败，或者服务器内部错误，没有数据返回
 */


+ (void)HVJSONDataWithDic:(NSDictionary *)paramDict success:(void (^)(id json))success codeError:(void(^)(int errorCode))codeError  fail:(void (^)())fail Setting:(HSNetSetting*)netSettting
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10.f;//设置请求超时的时间
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"image/png", nil];
    //[manager.requestSerializer setValue:@"headers" forHTTPHeaderField:@"Referer: http://www.vyanke.com\n"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:paramDict];
        NSString * url;
        NSDictionary * param;
        //拼接将要访问的URL地址
       // NSDictionary * dict2 = [HSNetUrlProcess createCompDictWithParm:dict];
       // NSString * value = [dict2 mj_JSONString];
       // url = [HSNetUrlProcess createHeadURL:dict];
        NSLog(@"URL是%@",url);
    if (netSettting.isEncry==YES) {
       // param = @{@"param":[EncryProcess textEncrypt:value]};
        //NSLog(@"加密后完整参数%@",[EncryProcess textEncrypt:value]);
    }
    else
    {
    //    param = dict2;
    }
    
    if (netSettting.askMethod == NetMethodPOST) {
        
            [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //解密处理
            NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (netSettting.isEncry) {
                //str = [EncryProcess textDecrypt:str];
                NSLog(@"解密后的参数=%@",str);
            }

            NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            int code = [JSON[@"result_code"]intValue];
            if (success&&code==NetCode_NETWORK_SUCCESS) {
                success(JSON);
                return;
            }
            switch (code) {
                case NetCode_COMMON_ERRPOR:
                    //[HSCoverView showMessage:JSON[@"message"]];
                    break;
                case NetCode_RESULT_NEWEST://最新数据不处理
                    break;
                case NetCode_VERSION_TOO_LOW://提示更新
                    //[HSCoverView showMessage:JSON[@"message"]];
                    break;
                case NetCode_IMAGE_CODE_ERROR://交给下层处理
                    //[HSCoverView showMessage:JSON[@"message"]];
                    break;
                case NetCode_TOKEN_EXPIRE_ERROR://
                    //[HSCoverView showMessage:JSON[@"message"]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];//消失
                        //这里是从UIWindow开始获取当前控制器的导航栏跳转到登陆界面
                        /*
                        UIWindow * window = [[UIApplication sharedApplication]keyWindow];
                        HSTabbarViewController * tabbar =(HSTabbarViewController*)window.rootViewController;
                        if ([tabbar isKindOfClass:[HSTabbarViewController class]] ) {
                            HSNavigationViewController* currentNav = tabbar.childViewControllers[tabbar. selectedIndex];
                            if (![[currentNav.childViewControllers lastObject]isKindOfClass:[HSLoginController class]]) {
                                HSLoginController * log = [[HSLoginController alloc]init];                            log.hidesBottomBarWhenPushed =YES;
                                [currentNav pushViewController:log animated:YES];
                            }
                        }
                        else
                        {
                            //这里就是意外了
                        }*/
                    });
                    break;
                default:
                    break;
            }
            if (code!= NetCode_NETWORK_SUCCESS&&codeError!=nil) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    codeError(code);//这里必须写,否则tableView在使用本类的时候无法停止刷新。一直处于刷新状态.需要在调用者里面继续调用。
                });
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSString * tips = [NSString stringWithFormat:@"%ld %@",(long)error.code,error.userInfo[@"NSLocalizedDescription"]];
            NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            NSString * message = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"服务器的错误原因:%@",message);
           // [HSCoverView showMessage:tips];
            if (fail) {
                fail(error);
            }
        }];

    }
    else if(netSettting.askMethod ==NetMethodGET)
    {
        [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //解密处理
            NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
          //  NSString * decodeStr = [EncryProcess textDecrypt:str];
            //NSLog(@"解密后的参数=%@",decodeStr);
            NSData *jsonData = [decodeStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            int code = [JSON[@"result_code"]intValue];
            if (success&&code==NetCode_NETWORK_SUCCESS) {
                success(JSON);
                return;
            }
            switch (code) {
                case NetCode_COMMON_ERRPOR:
               //     [HSCoverView showMessage:JSON[@"message"]];
                    break;
                case NetCode_RESULT_NEWEST://最新数据不处理
                    break;
                case NetCode_VERSION_TOO_LOW://提示更新
                 //   [HSCoverView showMessage:JSON[@"message"]];
                    break;
                case NetCode_IMAGE_CODE_ERROR://交给下层处理
                   // [HSCoverView showMessage:JSON[@"message"]];
                    break;
                case NetCode_TOKEN_EXPIRE_ERROR://
                    //[HSCoverView showMessage:JSON[@"message"]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];//消失
                        /*
                        UIWindow * window = [[UIApplication sharedApplication]keyWindow];
                        HSTabbarViewController * tabbar =(HSTabbarViewController*)window.rootViewController;
                        if ([tabbar isKindOfClass:[HSTabbarViewController class]] ) {
                            HSNavigationViewController* currentNav = tabbar.childViewControllers[tabbar. selectedIndex];
                            if (![[currentNav.childViewControllers lastObject]isKindOfClass:[HSLoginController class]]) {
                                HSLoginController * log = [[HSLoginController alloc]init];                            log.hidesBottomBarWhenPushed =YES;
                                [currentNav pushViewController:log animated:YES];
                            }
                        }
                        else
                        {
                            //这里就是意外了
                        }*/
                    });
                    break;
                default:
                    break;
            }
            if (code!= NetCode_NETWORK_SUCCESS&&codeError!=nil) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    codeError(code);//这里必须写,否则tableView在使用本类的时候无法停止刷新。一直处于刷新状态.需要在调用者里面继续调用。
                });
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSString * tips = [NSString stringWithFormat:@"%ld %@",(long)error.code,error.userInfo[@"NSLocalizedDescription"]];
            NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            NSString * message = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"服务器的错误原因:%@",message);
          //  [HSCoverView showMessage:tips];
            if (fail) {
                fail(error);
            }
        }];

    }
    
}


+(void)HVDataCache:(NSDictionary *) param NetBlock:(void (^)(NSDictionary *json))success ErrorCode :(void(^)(int errorCode))codeError Fail:(void(^)())fail Setting:(HSNetSetting*)netSettting
{
    HSNetSetting * set = netSettting ;
    if (set == nil ) {
        set = [HSNetSetting noSaveCacheSet];//默认
        set.isEncry = NO;
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:param];
    NSString * sqliteKey = [HSNetUrlProcess createSqliteKeyWithParm:dict];
    JsonCacheData * data = [SQLiteJsonCache queryJsonCacheTableWithKey:sqliteKey];
    //读缓存，后面的null是服务器最近返回的错误数据，
    if (data.jsonCache.length>0&&(set.cachePolicy>HSCacheNoRead)&&(![data.jsonCache isEqualToString:@"(null)"]))
    {
        if (data.jsonCache.length>0) { //如果缓存存在, 有缓存就显示，并且缓存时间要大于0否则就没有意义
            if (success!=nil) {
                success(data.JsonData);
            }
            if (data.isExpire) { //要把version带上，服务器用于md5计算，是否返回数据
                if ([data.JsonData[@"version"]length]>0) {
                    dict[@"version"]=data.JsonData[@"version"];
                }
                [AFNetworkTool HVJSONDataWithDic:dict success:^(id json) {
                    //加密
                    [SQLiteJsonCache insertJsonCacheDictWithKey:sqliteKey andWithValue:json andWithExpireTime:60*set.cachePolicy];
                    success(json);

                } codeError:^(int errorCode) {
                    if (codeError!=nil) {
                        if (errorCode==NetCode_RESULT_NEWEST) { //更新缓存的时间
                            [SQLiteJsonCache insertJsonCacheDictWithKey:sqliteKey andWithValue:data.JsonData andWithExpireTime:set.cachePolicy*60];
                        }
                        codeError(errorCode);
                    }
                } fail:^{
                    if (fail!=nil) {
                        fail();
                    }
                } Setting:set];
            }
        }
    }
    else
    {
        if (!set.isCtrlHub) {
            [SVProgressHUD show];
        }
        
        [AFNetworkTool HVJSONDataWithDic:dict success:^(id json) {
            [SVProgressHUD dismiss];
            if (set.cachePolicy!=HSCacheNoSave) {//判断是不是  不存缓存
                [SQLiteJsonCache insertJsonCacheDictWithKey:sqliteKey andWithValue:json andWithExpireTime:set.cachePolicy*60];
            }
            success(json);
            if (!set.isCtrlHub) {
                [SVProgressHUD dismiss];
            }

        } codeError:^(int errorCode) {
            if (codeError!=nil) {
                codeError(errorCode);
            }
            if (!set.isCtrlHub) {
                [SVProgressHUD dismiss];
            }

        } fail:^{
            
            [SVProgressHUD dismiss];
            if (fail!=nil) {
            fail();
        }
        } Setting:set];
    }
}

+(void)initialize
{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setMinimumDismissTimeInterval:2.0];

}

@end
