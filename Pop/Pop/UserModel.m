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

/**
 * @property (readonly, copy) NSString *description;
 * description是NSObject的一个只读属性，对于一般的属性都会有getter和setter方法，但是readonly的属性顾名思义就只有getter方法啦。
 * 当你在XCode控制台使用po命令打印一个对象的时候，如果没有重写description方法，往往打印出的结果就是“类名＋内存地址”，当然，我们只对继承自NSObject的非responder类对象感兴趣
 * 细心的你会发现UIResponder继承自NSObject
 * 这就是为什么UIViewController、UIView等控件们也有description方法了
 * description 顾名思义是描述的意思，就是说一个对象有什么属性，每个属性对应的属性值是什么，
 * 关于怎样重写description方法，不管是听说还是看博客，相信你一定有自己的想法了，关于如何写一个通用的description方法，请拷贝一下代码到你的类中，测试一下有没有很爽
 * 在拷贝代码之后如果你看到了红色的报错，说明你忘记import "objc/runtime.h"啦，至于runtime是什么鬼东西，网上有很多博客，我知道自己写不好，就不妖言惑众了。
 */
- (NSString *)description{
    //当然，如果你有兴趣知道出类名字和该对象的内存地址，也可以调用super的description方法
//    NSString * desc = [super description];
    NSString * desc = @"\n";
    
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



@end
