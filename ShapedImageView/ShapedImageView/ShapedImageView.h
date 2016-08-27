//
//  ShapedImageView.h
//  Boobuz
//
//  Created by songmeng on 16/8/11.
//  Copyright © 2016年 erlinyou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShapedImageView : UIView

@property (nonatomic, strong) UIImage   * image;
@property (nonatomic, copy) void(^removeMessage)();

- (instancetype)initWithDirectionRight:(BOOL)right;



@end
