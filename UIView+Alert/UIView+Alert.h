//
//  UIView+Alert.h
//  TestTableViewCell
//
//  Created by songmeng on 16/1/22.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(Byte,ToastPosition){
    toastPositionCenter = 0,
    toastPositionBottom = 1 << 0
};

typedef NS_ENUM(Byte,WaitingPosition) {
    waitingPositionUpToDown     = 0,
    waitingPositionDownToUp     = 1 << 0,
    waitingPositionLeftToRight  = 1 << 1,
    waitingPositionRightToLeft  = 1 << 2
};

@interface UIView (Alert) 

#pragma mark    ------ alert ------
- (void)makeAlertWithTitle:(NSString *)title message:(NSString *)message duration:(CGFloat)seconds;
- (void)makeAlertWithTitle:(NSString *)title message:(NSString *)message duration:(CGFloat)seconds position:(ToastPosition)position;

#pragma mark    ------ waiting ------
- (void)waitingWithMessage:(NSString *)message position:(WaitingPosition)position;

@end
