//
//  SomeImage.m
//  SomePhotoBrowser
//
//  Created by songmeng on 16/7/12.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import "SomeImage.h"
#import "objc/runtime.h"


@interface SomeImage ()

//prvate property

@end

@implementation SomeImage

- (instancetype)initWithUrl:(NSURL *)url detail:(NSString *)detail{
	self = [super init];
	if (self){
		//property init
        self.imageUrl = url;
        self.detail = detail;
	}
	return self;
}

- (instancetype)initWithImage:(UIImage *)image detail:(NSString *)detail{
    self = [super init];
    if (self) {
        
        self.detail = detail;
    }
    return self;
}

#pragma mark - private method

#pragma mark - public method 
+ (nullable SomeImage *)someImageWithURL:(nullable NSURL *)url detail:(nullable NSString *)detail{
    return [[SomeImage alloc] initWithUrl:url detail:detail];
}


+ (nullable SomeImage *)someImageWithImage:(nullable UIImage *)image detail:(nullable NSString *)detail{
    return [[SomeImage alloc] initWithImage:image detail:detail];
}




- (NSString *)description{
    NSString * desc = @"\n";
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        const char * propName = property_getName(property);
        if (propName) {
            NSString    * prop = [NSString stringWithCString:propName encoding:[NSString defaultCStringEncoding]];
            id obj = [self valueForKey:prop];
            desc = [desc stringByAppendingString:prop];
            desc = [desc stringByAppendingString:@": "];
            NSString    * value = [NSString stringWithFormat:@"%@",obj];
            desc = [desc stringByAppendingString:value];
            desc = [desc stringByAppendingString:@" ; "];
        }
    }
    
    free(properties);
    return desc;
}

@end
