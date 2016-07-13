//
//  UserModel.m
//  Pop
//
//  Created by songmeng on 16/7/5.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import "UserModel.h"
#import "objc/runtime.h"


@implementation UserModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.name = @"liming ";
        self.age = 24;
        self.height = 180.5;
        self.friends = @[@15,@"hello",@[]];
    }
    return self;
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
