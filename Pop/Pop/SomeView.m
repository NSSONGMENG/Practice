//
//  SomeView.m
//  Pop
//
//  Created by songmeng on 16/8/12.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import "SomeView.h"

@interface SomeView ()
//view make as private
//use public data interface set value to them

@end

@implementation SomeView

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
