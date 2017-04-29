//
//  ViewController.m
//  HSNetWork
//
//  Created by 王国栋 on 17/4/30.
//  Copyright © 2017年 xiaobai. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworkTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AFNetworkTool HVDataCache:@{@"param1":@"param1_value",@"param2":@"param2_val"} NetBlock:^(NSDictionary *json) {
        
        //成功的代码
    } ErrorCode:^(int errorCode) {
        //可能会处理的code_error
    } Fail:^{
        //失败
    } Setting:self.defaultSet];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
