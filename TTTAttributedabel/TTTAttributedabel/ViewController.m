//
//  ViewController.m
//  TTTAttributedabel
//
//  Created by songmeng on 16/8/27.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import "ViewController.h"
#import "TTTAttributedLabel.h"
#import "Masonry.h"

#define MESSAGE_MAX_WIDTH   300

@interface ViewController ()<TTTAttributedLabelDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    TTTAttributedLabel  * messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    messageLabel.backgroundColor = [UIColor whiteColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    messageLabel.delegate = self;
    //这里只匹配链接和电话号码
    messageLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
    messageLabel.selectionArray = @[@"复制",@"删除"];
    messageLabel.callBackSelection = ^(NSString * title,NSInteger selectionIndex){
        NSLog(@"title : %@  index : %ld",title,selectionIndex);
        //复制在label内部，其他功能自定义实现
    };
    NSString * message = @"百度www.baidu.com 邮箱:12345678@qq.com 电话:15237012513(高中是、时用的号码，现在不用了,别想着通过电话联系我啊)";
    [self.view addSubview:messageLabel];
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
        make.width.lessThanOrEqualTo(@(MESSAGE_MAX_WIDTH));
    }];
    
    //setText:方法也可以
    //不过用下面这个方法可以方便的计算高度
    __block CGFloat labelHeight = 0;
    [messageLabel setText:message afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        labelHeight = [TTTAttributedLabel sizeThatFitsAttributedString:mutableAttributedString
                                                  withConstraints:CGSizeMake(MESSAGE_MAX_WIDTH, MAXFLOAT)
                                           limitedToNumberOfLines:0].height;
        return mutableAttributedString;
    }];
    NSLog(@"%f",labelHeight);
}

#pragma  mark  -
#pragma  mark  --------- label delegate ---------
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    NSString    * urlStr = [NSString stringWithFormat:@"%@",url];
    if ([urlStr containsString:@"@"]) {
        NSString    * email = [NSString stringWithFormat:@"mailto://%@",urlStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    }else{
        NSLog(@"链接: %@",url);
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber{
    NSLog(@"电话 : %@",phoneNumber);
    NSString    * call = [NSString stringWithFormat:@"tel://%@",phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:call]];
}

- (void)attributedLabel:(TTTAttributedLabel *)label willShowMenuWithText:(id)text{
    label.backgroundColor = [UIColor lightGrayColor];
}

- (void)attributedLabel:(TTTAttributedLabel *)label willHideMenuWithText:(id)text{
    label.backgroundColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
