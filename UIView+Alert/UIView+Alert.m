//
//  UIView+Alert.m
//  TestTableViewCell
//
//  Created by songmeng on 16/1/22.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import "UIView+Alert.h"

@implementation UIView (Alert)

#pragma mark    ------ alert ------
- (void)makeAlertWithTitle:(NSString *)title message:(NSString *)message duration:(CGFloat)seconds position:(ToastPosition)position{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:position == toastPositionCenter ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];

    [[self topViewController] presentViewController:alert animated:YES completion:^{
        //延时seconds秒之后执行block内的操作
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (void)makeAlertWithTitle:(NSString *)title message:(NSString *)message duration:(CGFloat)seconds{
    [self makeAlertWithTitle:title message:message duration:seconds position:toastPositionCenter];
}

//获取最上层controller
- (UIViewController *)topViewController{
    UIViewController * rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UIViewController * topVC = rootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

#pragma mark    ------ waiting ------
- (void)waitingWithMessage:(NSString *)message position:(WaitingPosition)position{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
