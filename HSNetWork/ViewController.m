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

@property (nonatomic,strong) UITextView * textF;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor redColor]];
    
    self.textF = [[UITextView alloc]initWithFrame:CGRectMake(0, 250, 350, 200)];
    self.textF.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.textF];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)reload{
    
    self.textF.text = @"";
    [AFNetworkTool HVDataCache:@{@"tab_id":@"215556ba35e46801a3b67cef3dc7041b",@"app_ver":@"2.2.10"} NetBlock:^(NSDictionary *json) {
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&parseError];
        
         self.textF.text = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        //成功的代码
    } ErrorCode:^(int errorCode) {
        //可能会处理的code_error
    } Fail:^{
        //失败
    } Setting:self.defaultSet];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
