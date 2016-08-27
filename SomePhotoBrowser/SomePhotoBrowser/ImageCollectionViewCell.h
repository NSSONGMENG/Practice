//
//  ImageCollectionViewCell.h
//  SomePhotoBrowser
//
//  Created by songmeng on 16/7/12.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SomeImage;

@interface ImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) SomeImage   * img;
@property (nonatomic, copy) NSString    * titleString;


@end
