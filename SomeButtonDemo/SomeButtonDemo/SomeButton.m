//
//  SomeButton.m
//  SomeButtonDemo
//
//  Created by songmeng on 17/1/13.
//  Copyright © 2017年 songmeng. All rights reserved.
//

#import "SomeButton.h"
#import "Masonry.h"

@interface SomeButton ()

@property (nonatomic, strong)BtnContentView * contentView;

@end

@implementation SomeButton

- (instancetype)init{
    self = [super init];
    if (self){
        [self createSubview];
    }
    return self;
}

- (void)createSubview{
//    _contentView = [BtnContentView new];
//    _imageView = _contentView.imgview;
//    _titleLabel = _contentView.titleLab;
//    [self addSubview:_contentView];
//    
//    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
//        make.right.bottom.greaterThanOrEqualTo(self).offset(0);
//    }];
    UIView  * view = [UIView new];
    view.backgroundColor = [UIColor yellowColor];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [_contentView setBackgroundColor:backgroundColor];
}

- (void)setMode:(ContentRangeMode)mode{
    _mode = mode;
    [_contentView setMode:mode];
}

- (void)setInterval:(CGFloat)interval{
    _interval = interval;
    [_contentView setInterval:interval];
}

- (void)setImageViewHeight:(CGFloat)imageViewHeight{
    _imageViewHeight = imageViewHeight;
    [_contentView setImgHeight:imageViewHeight];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    NSLog(@"%s", __FUNCTION__);
    
}

// 当用户点击到当前控件bounds时，会调用该方法，返回值决定了当前控件是否响应该事件
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    //    NSLog(@"%s-touch=[%@]-event=[%@]", __FUNCTION__, touch, event);
    NSLog(@"state=[%zd]", self.state);
    return YES;
    //    return NO;
    //    return [super beginTrackingWithTouch:touch withEvent:event]; // 返回系统默认处理
}

// 如果 beginTrackingWithTouch 返回值 为YES，则以下方法 会在 点击手机屏幕移动 时 调用，如果这里返回值为YES，则继续移动会多次调用。
// 如果 返回 NO，则 即使 继续移动也不会再调用当前方法了。
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    //    NSLog(@"%s-touch=[%@]-event=[%@]", __FUNCTION__, touch, event);
    NSLog(@"state=[%zd]", self.state);
    
    // 这里发送 点击 事件时，外部会调用 对应的事件处理方法
    //    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    return YES;
    //    return NO;
    //    return [super beginTrackingWithTouch:touch withEvent:event];  // 返回系统默认处理
}

// 当点击屏幕释放时，调用该方法
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    //    NSLog(@"%s-touch=[%@]-event=[%@]", __FUNCTION__, touch, event);
    NSLog(@"state=[%zd]", self.state);
    [super endTrackingWithTouch:touch withEvent:event];  // 系统默认处理
}

// 取消时会调用，如果当前视图被移除。或者来电
- (void)cancelTrackingWithEvent:(nullable UIEvent *)event {
    //    NSLog(@"%s-event=[%@]", __FUNCTION__, event);
    NSLog(@"state=[%zd]", self.state);
    [super cancelTrackingWithEvent:event];  // 系统默认处理
}

@end
