//
//  ViewController.m
//  ShapedImageView
//
//  Created by songmeng on 16/8/27.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import "ViewController.h"
#import "ShapedImageView.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    ShapedImageView * imgView0 = [[ShapedImageView alloc] initWithDirectionRight:YES];
    [self.view addSubview:imgView0];
    [imgView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(30);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(@320);
    }];
    
    
    ShapedImageView * imgview1 = [[ShapedImageView alloc] initWithDirectionRight:NO];
    [self.view addSubview:imgview1];
    [imgview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView0.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@255);
        make.height.mas_equalTo(165);
        //这里用equal和mas_equal是一样的，主要目的就是为了让不了解Masonry的朋友能熟悉这两种实质上相同的设置方式
        //当然这里的@200是一种语法糖，和[NSNumber numberWithInteger:200]的意思一致
        //其实还有一种比较鲜为人知的语法糖如下：
//        NSInteger   inte = 50;
//        NSNumber    * num = @(inte);
        //其实这里@(基本类型变量)也是一种NSNumber语法糖
    }];
    
    //设置图片
    imgView0.image = [UIImage imageNamed:@"right"];
    imgview1.image = [UIImage imageNamed:@"left"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
