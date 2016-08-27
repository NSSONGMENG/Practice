//
//  ImageBrowserCell.m
//  SomePhotoBrowser
//
//  Created by songmeng on 16/7/12.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import "ImageBrowserCell.h"
#import "SomeImage.h"

@interface ImageBrowserCell ()

@property (nonatomic, strong)UIImageView    * imageView;

@end


@implementation ImageBrowserCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
    }
    return self;
}


- (void)createSubview{
    _imageView = [UIImageView new];
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.backgroundColor = [UIColor blackColor];
    [self addSubview:_imageView];
    
    UITapGestureRecognizer  * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction)];
    [_imageView addGestureRecognizer:tap];


    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)tapImageAction{
    if (self.callBackTapImageAction) {
        self.callBackTapImageAction(_image);
    }
}

- (void)setImage:(SomeImage *)image{
    _image = image;
    _imageView.image = _image.image;
}

@end
