//
//  UserModel.h
//  Pop
//
//  Created by songmeng on 16/7/5.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

#pragma mark - property
@property (nonatomic, strong) NSString  * name;
@property (nonatomic, assign) NSInteger     age;
@property (nonatomic, assign) CGFloat       height;
@property (nonatomic, strong) NSArray   * friends;


#pragma mark - api
- (instancetype)init;

@end
