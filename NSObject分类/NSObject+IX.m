//
//  NSObject+IX.m
//  IXApp
//
//  Created by Seven on 2017/8/18.
//  Copyright © 2017年 IX. All rights reserved.
//

#import "NSObject+IX.h"

@implementation NSObject (IX)

- (BOOL)ix_isDictionary
{
    return [self isKindOfClass:[NSDictionary class]];
}

- (BOOL)ix_isArray
{
    return [self isKindOfClass:[NSArray class]];
}

- (BOOL)ix_isNull
{
    return [self isKindOfClass:[NSNull class]];
}

- (BOOL)ix_isString
{
    return [self isKindOfClass:[NSString class]];
}

/** 是否是NSNumber类型 */
- (BOOL)ix_isNumber
{
    return [self isKindOfClass:[NSNumber class]];
}


@end
