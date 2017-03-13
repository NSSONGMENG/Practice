//
//  BtnContentView.m
//  SomeButtonDemo
//
//  Created by songmeng on 17/1/13.
//  Copyright © 2017年 songmeng. All rights reserved.
//

#import "BtnContentView.h"
#import "Masonry.h"

@implementation BtnContentView

- (instancetype)init{
    if (self = [super init]) {
        _interval = 5.f;
        _imgHeight = 30.f;
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self createSubview];
        [self layoutSubview];
    }
    return self;
}

- (void)createSubview{
    _imgview = [UIImageView new];
    _imgview.contentMode = UIViewContentModeScaleAspectFill;
    _imgview.backgroundColor = [UIColor clearColor];
    _imgview.userInteractionEnabled = YES;
    [self addSubview:_imgview];
    
    _titleLab = [UILabel new];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.userInteractionEnabled = YES;
    [self addSubview:_titleLab];
}

- (void)layoutSubview{
    [_imgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(_titleLab.mas_left).offset(-_interval);
        make.width.height.mas_equalTo(_imgHeight);
    }];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self).offset(0);
        make.centerY.equalTo(self);
        make.right.equalTo(self);
    }];
}

- (void)setInterval:(CGFloat)interval{
    _interval = interval;
    [_imgview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleLab.mas_left).offset(interval);
    }];
    [self layoutIfNeeded];
}

- (void)setMode:(ContentRangeMode)mode{
    _mode = mode;
    switch (mode) {
        case contentRangeModeImageInRight:{
            [_imgview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self);
                make.left.equalTo(_titleLab.mas_right).offset(_interval);
            }];
            [_titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
            }];
            break;
        }
        case contentRangeModeHideImageView:{
            [_imgview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            [_titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
            }];
            break;
        }
        case contentRangeModeHideTitle:{
            [_titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            [_imgview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.left.equalTo(self);
            }];
            break;
        }
        default:
            break;
    }
    [self layoutIfNeeded];
}

- (void)setImgHeight:(CGFloat)imgHeight{
    _imgHeight = imgHeight;
    [_imgview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(imgHeight);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
