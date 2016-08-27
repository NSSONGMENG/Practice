//
//  ImageBrowserCell.h
//  SomePhotoBrowser
//
//  Created by songmeng on 16/7/12.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SomeImage;

@interface ImageBrowserCell : UICollectionViewCell

@property (nonatomic, strong) SomeImage * image;
@property (nonatomic, copy) void(^callBackTapImageAction)(SomeImage *image);


@end
