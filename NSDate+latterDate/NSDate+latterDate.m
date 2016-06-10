//
//  NSDate+latterDate.m
//  Boobuz
//
//  Created by songmeng on 16/5/30.
//  Copyright © 2016年 erlinyou.com. All rights reserved.
//

#import "NSDate+latterDate.h"

@implementation NSDate (latterDate)


/**
 * @method
 *
 * @brief 获取当前时间之后若干月之后的时间
 * @param months       月数
 * @return    NSDate
 */
+ (NSDate *)latterDateWithMonths:(NSInteger)months{
    return [NSDate dateWithFromDate:nil years:0 months:months days:0];
}

+ (NSDate *)latterDateWithDate:(NSDate *)date months:(NSInteger)months{
    return [NSDate dateWithFromDate:date years:0 months:months days:0];
}


/**
 * @method
 *
 * @brief 获取当前时间之后若干天之后的时间
 * @param day       天数
 * @return    NSDate
 */
+ (NSDate *)latterDateWithDays:(NSInteger)days{
    return [NSDate dateWithFromDate:nil years:0 months:0 days:days];
}

+ (NSDate *)latterDateWithDate:(NSDate *)date days:(NSInteger)days{
    return [NSDate dateWithFromDate:date years:0 months:0 days:days];
}


/**
 * @method
 *
 * @brief 获取当前时间之后若干年之后的时间
 * @param years       年数
 * @return    NSDate
 */
+ (NSDate *)latterDateWithYears:(NSInteger)years{
    return [NSDate dateWithFromDate:nil years:years months:0 days:0];
}

+ (NSDate *)latterDateWithDate:(NSDate *)date years:(NSInteger)years{
    return [NSDate dateWithFromDate:date years:years months:0 days:0];
}


//获取当前时间若干天后的时间
+ (NSDate *)dateWithFromDate:(NSDate *)date years:(NSInteger)years months:(NSInteger)months days:(NSInteger)days{
    NSDate  * latterDate;
    if (date) {
        latterDate = date;
    }else{
        latterDate = [NSDate date];
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|
                                                    NSCalendarUnitMonth|
                                                    NSCalendarUnitDay|
                                                    NSCalendarUnitHour|
                                                    NSCalendarUnitMinute
                                          fromDate:latterDate];

    [comps setYear:years];
    [comps setMonth:months];
    [comps setDay:days];

    return [calendar dateByAddingComponents:comps toDate:latterDate options:0];
}

/**
 * @method
 *
 * @brief 获取两个日期之间的天数
 * @param fromDate       起始日期
 * @param toDate         终止日期
 * @return    总天数
 */
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents    * comp = [calendar components:NSCalendarUnitDay
                                             fromDate:fromDate
                                               toDate:toDate
                                              options:NSCalendarWrapComponents];
    NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.day;
}

/**
 * @method
 *
 * @brief 获取从现在开始几个月内的天数
 * @param months       月份数
 * @return    总天数
 */
+ (NSInteger)numberOfDaysFromNowWithMonths:(NSInteger)months{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents    * comp = [calendar components:NSCalendarUnitDay
                                             fromDate:[NSDate date]
                                               toDate:[NSDate latterDateWithMonths:months]
                                              options:NSCalendarWrapComponents];
    NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.day;
}

@end
