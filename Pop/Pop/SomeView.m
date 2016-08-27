//
//  SomeView.m
//  Pop
//
//  Created by songmeng on 16/8/12.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import "SomeView.h"
#import "objc/runtime.h"

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

- (NSString *)description{
    NSString * desc = [super description];
    
    unsigned int outCount;
    //获取class的属性数目
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        //获取property的C字符串
        const char * propName = property_getName(property);
        if (propName) {
            //获取NSString类型的property名字
            NSString    * prop = [NSString stringWithCString:propName encoding:[NSString defaultCStringEncoding]];
            //获取property对应的值
            id obj = [self valueForKey:prop];
            //将属性明和属性值拼接起来
            desc = [desc stringByAppendingFormat:@"%@ : %@;\n",prop,obj];
        }
    }
    
    free(properties);
    return desc;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
