//
//  YGViewController.m
//  YGAnalysisKit
//
//  Created by gjzxwyg@163.com on 08/06/2020.
//  Copyright (c) 2020 gjzxwyg@163.com. All rights reserved.
//

#import "YGViewController.h"
#import "TESTViewController.h"

@interface YGViewController ()

@end

@implementation YGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// 配置文件一般从后台获取，文件的形式和内容可以根据自己的需求进行改变，项目中的test.plist仅作为演示
   
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *title = @[@"无埋点",@"埋点1",@"埋点2"];
    for (int i = 0; i<3; i++)
    {
        //埋点情况看打印
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100*i, 150, 80, 40);
        btn.backgroundColor = [UIColor redColor];
        btn.tag = i;
        [btn setTitle:title[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testTap:)];
    
    [self.view addGestureRecognizer:tap];
    
}

-(void)testClick:(UIButton*)sender
{
    if (sender.tag==2)
    {
        [self.navigationController pushViewController:[TESTViewController new] animated:YES];
    }
}

-(void)testTap:(UIGestureRecognizer*)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
