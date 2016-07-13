//
//  SomePhotoBrowser.m
//  SomePhotoBrowser
//
//  Created by songmeng on 16/7/12.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import "SomePhotoBrowser.h"

@interface SomePhotoBrowser ()

@property (nonatomic, strong)NSArray    * imageArray;
@property (nonatomic, assign)NSInteger  * initIndex;

@end

@implementation SomePhotoBrowser

- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSInteger)index{
    self = [SomePhotoBrowser new];
    _imageArray = photos;
    _initIndex = index;
    return self;
}
- (instancetype)init{
	self = [super init];
	if (self){
		[self createSubview];	
	}
	return self;
}

#pragma mark - create UI
- (void)createSubview{

}

#pragma mark - view event

#pragma mark - private method

#pragma mark - public method 

#pragma mark - setter

#pragma mark - getter


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
