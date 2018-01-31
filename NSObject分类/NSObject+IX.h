//
//  NSObject+IX.h
//  IXApp
//
//  Created by Seven on 2017/8/18.
//  Copyright © 2017年 IX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (IX)


/** 是否是字典类型 */
- (BOOL)ix_isDictionary;

/** 是否是数组类型 */
- (BOOL)ix_isArray;

/** 是否是null类型 */
- (BOOL)ix_isNull;

/** 是否是字符串类型 */
- (BOOL)ix_isString;

/** 是否是NSNumber类型 */
- (BOOL)ix_isNumber;

@end
