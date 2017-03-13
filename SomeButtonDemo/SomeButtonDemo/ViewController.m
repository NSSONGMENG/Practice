//
//  ViewController.m
//  SomeButtonDemo
//
//  Created by songmeng on 17/1/13.
//  Copyright © 2017年 songmeng. All rights reserved.
//

#import "ViewController.h"
#import "SomeButton.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SomeButton  * btn0 = [SomeButton new];
    btn0.backgroundColor = [UIColor lightGrayColor];
    btn0.titleLabel.text = @"按钮0";
    btn0.imageView.backgroundColor = [UIColor yellowColor];
//    [btn0 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn0 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn0];
    
    [btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(60);
    }];
    
    
}

- (void)btnAction:(id)sender{
    NSLog(@" -- %s -- ",__func__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
