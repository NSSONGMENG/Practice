//
//  SomePhotoBrowser.h
//  SomePhotoBrowser
//
//  Created by songmeng on 16/7/12.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SomePhotoBrowser;
@class SomeImage;

@protocol SomePhotoBrowserDelegate <NSObject>

- (void)somePhotoBrowser:(SomePhotoBrowser *)browser tapImageAction:(SomeImage *)image;

@end


@interface SomePhotoBrowser : UIView


@property (readonly, nonatomic, assign) BOOL      labelShow;
@property (nonatomic, strong) NSArray   * imgArray;
@property (nonatomic, assign) id <SomePhotoBrowserDelegate>delegate;

#pragma mark - api

- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSInteger)index;
- (void)showWithIndex:(NSInteger)currentIndex;

@end
