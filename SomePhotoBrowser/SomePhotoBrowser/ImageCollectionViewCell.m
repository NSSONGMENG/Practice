//
//  ImageCollectionViewCell.m
//  SomePhotoBrowser
//
//  Created by songmeng on 16/7/12.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#import "SomeImage.h"

@interface ImageCollectionViewCell ()

@property (nonatomic, strong)UIImageView    * imageView;
@property (nonatomic, strong)UILabel        * titleLabel;

@end

@implementation ImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
    }
    return self;
}

- (void)createSubview{
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    [self addSubview:_titleLabel];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(35);
    }];
}

- (void)setTitleString:(NSString *)titleString{
    if (titleString) {
        _titleLabel.hidden = NO;
    }else{
        _titleLabel.hidden = YES;
    }
    _titleString = titleString;
    _titleLabel.text = titleString;
}

- (void)setImg:(SomeImage *)image{
    _img = image;
    _imageView.image = _img.image;
}


@end
