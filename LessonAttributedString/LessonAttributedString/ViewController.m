//
//  ViewController.m
//  LessonAttributedString
//
//  Created by songmeng on 15/7/19.
//  Copyright (c) 2015年 songmeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, self.view.frame.size.width-100, 200)];
    lable.backgroundColor = [UIColor lightGrayColor];
    lable.numberOfLines = 0;
    [self.view addSubview:lable];
    
    NSString * string = @"Always believe that something wonderful is about \nto happen！";
    
    //富文本
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    //段落样式
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
#warning  lable.numberOfLines必须为0，段落样式才生效
    //行间距
    paragraphStyle.lineSpacing = 10.0;
    //段落间距
    paragraphStyle.paragraphSpacing = 20.0;

//    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
//    paragraphStyle.firstLineHeadIndent = 10.0;
//    paragraphStyle.headIndent = 50.0;
//    paragraphStyle.tailIndent = 200.0;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, string.length)];
    
    lable.attributedText = attributedString;
    
 
    UILabel * aLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 500, 200, 40)];
    aLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:aLable];
    
    NSString * aString = @"¥150 元/位";
    
    //富文本对象
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:aString];
    
    //富文本样式
    [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
                              value:[UIColor redColor]
                              range:NSMakeRange(0, 4)];
    
    [aAttributedString addAttribute:NSFontAttributeName             //文字大小
                              value:[UIFont systemFontOfSize:25]
                              range:NSMakeRange(0, 4)];
    
//    [aAttributedString addAttribute:NSStrokeColorAttributeName      //文字颜色
//                              value:[UIColor greenColor]
//                              range:NSMakeRange(0, 4)];
    
//    [aAttributedString addAttribute:NSStrokeWidthAttributeName    //空心字体
//                              value:@3.0
//                              range:NSMakeRange(0, 4)];
    
//    [aAttributedString addAttribute:NSLigatureAttributeName         //连体
//                              value:@1
//                              range:NSMakeRange(0, 4)];
    
//    [aAttributedString addAttribute:NSUnderlineStyleAttributeName       //下划线宽
//                              value:@4
//                              range:NSMakeRange(0, 4)];
//    
//    [aAttributedString addAttribute:NSUnderlineColorAttributeName       //下划线颜色
//                              value:[UIColor greenColor]
//                              range:NSMakeRange(0, 4)];
//    
//    [aAttributedString addAttribute:NSBaselineOffsetAttributeName       //文字向上偏移量
//                              value:@5
//                              range:NSMakeRange(0, 4)];
    
    aLable.attributedText = aAttributedString;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
