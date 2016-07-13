//
//  SomePhotoBrowser.h
//  SomePhotoBrowser
//
//  Created by songmeng on 16/7/12.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SomePhotoBrowser;

@protocol SomePhotoBrowserDelegate <NSObject>



@end


@interface SomePhotoBrowser : UIView

#pragma mark - data property
- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSInteger)index;


#pragma mark - api

@end
