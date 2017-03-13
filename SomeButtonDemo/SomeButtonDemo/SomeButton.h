//
//  SomeButton.h
//  SomeButtonDemo
//
//  Created by songmeng on 17/1/13.
//  Copyright © 2017年 songmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BtnContentView.h"

@interface SomeButton : UIControl

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel   * titleLabel;

//图片文字布局
@property (nonatomic, assign)ContentRangeMode   mode;
//图片高度，默认30，本控件默认高度也是30
@property (nonatomic, assign)CGFloat    imageViewHeight;
//图片和文字的距离
@property (nonatomic, assign)CGFloat    interval;

@end
