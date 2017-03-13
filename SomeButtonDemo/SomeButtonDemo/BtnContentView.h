//
//  BtnContentView.h
//  SomeButtonDemo
//
//  Created by songmeng on 17/1/13.
//  Copyright © 2017年 songmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ContentRangeMode) {
    contentRangeModeImageInLeft,    //图左文字右
    contentRangeModeImageInRight,
    contentRangeModeHideImageView,  //隐藏图片
    contentRangeModeHideTitle,      //隐藏title
};

@interface BtnContentView : UIView

@property (nonatomic, strong)UIImageView    * imgview;
@property (nonatomic, strong)UILabel    * titleLab;
//imgView和titleLab之间的间隔
@property (nonatomic, assign)CGFloat    interval;
//默认为contentRangeModeImageInLeft
@property (nonatomic, assign)ContentRangeMode   mode;
//图片高度默认为30
@property (nonatomic, assign)CGFloat    imgHeight;

@end
