//
//  SomeImage.h
//  SomePhotoBrowser
//
//  Created by songmeng on 16/7/12.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SomeImage : NSObject

#pragma mark - property
@property (nonatomic, strong)UIImage    * image;
@property (nonatomic, strong)NSURL      * imageUrl;
@property (nonatomic, copy)NSString     * detail;

#pragma mark - api
+ (nullable SomeImage *)someImageWithURL:(nullable NSURL *)url detail:(nullable NSString *)detail;
+ (nullable SomeImage *)someImageWithImage:(nullable UIImage *)iamge detail:(nullable NSString *)detail;

@end
