//
//  ShapedImageView.h
//  Boobuz
//
//  Created by songmeng on 16/8/11.
//  Copyright © 2016年 erlinyou.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/CAShapeLayer.h>
#import "ShapedImageView.h"

@interface ShapedImageView ()

@property (nonatomic, strong) CALayer       * contentLayer;
@property (nonatomic, strong) CAShapeLayer  * maskLayer;

@end

@implementation ShapedImageView

- (instancetype)initWithDirectionRight:(BOOL)right{
    self = [super init];
    if (self) {
        [self createSubviewToRight:right];
    }
    return self;
}

- (void)layoutSubviews{
    _maskLayer.frame = self.bounds;
    _contentLayer.frame = self.bounds;
}

#pragma mark - create UI
- (void)createSubviewToRight:(BOOL)right{
    _maskLayer = nil;
    _contentLayer = nil;
    CGRect  rect = right ?  CGRectMake(0.3, 0.7, 0, 0) : CGRectMake(0.7, 0.7, 0, 0);
    NSString    * iconName = right ? @"icon_bubble_right" : @"icon_bubble_left";
    UIImage * image = [UIImage imageNamed:iconName];
    
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.frame = self.bounds;
    //关于contentCenter可以参考文章https://www.mgenware.com/blog/?p=489
    _maskLayer.contentsCenter =rect;
    
    //关于角的大小，一种简单的方法就是使用尺寸比较大的图icon_bubble_right和icon_bubble_left
    _maskLayer.contents = (id)image.CGImage;
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;                 //非常关键设置自动拉伸的效果且不变形
    
    _contentLayer = [CALayer layer];
    _contentLayer.mask = _maskLayer;
    _contentLayer.frame = self.bounds;
    [self.layer addSublayer:_contentLayer];
}


- (void)setImage:(UIImage *)image{
    _contentLayer.contents = (id)image.CGImage;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

@end