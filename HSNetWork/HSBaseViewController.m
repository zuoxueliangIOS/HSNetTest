//
//  HSBaseViewController.m
//  HSNetWork
//
//  Created by 王国栋 on 17/4/30.
//  Copyright © 2017年 xiaobai. All rights reserved.
//

#import "HSBaseViewController.h"

@interface HSBaseViewController ()

@end

@implementation HSBaseViewController

- (HSNetSetting *)defaultSet{
    if (_defaultSet==nil) {
        //读缓存
        _defaultSet = [HSNetSetting readCacheSet];
    }
    return _defaultSet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
