//
//  NSDate+latterDate.h
//  Boobuz
//
//  Created by songmeng on 16/5/30.
//  Copyright © 2016年 erlinyou.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (latterDate)

/**
 是否属于同一天判断
 
 @param time1 time1
 @param time2 time2
 @return 同一天为真，否则为假
 */
+ (BOOL)isInSameDay:(int64_t)time1 time2:(int64_t)time2;

/**
 是否属于同一周
 
 @param time1 time1
 @param time2 time2
 @return 同一周为真，否则为假
 */
+ (BOOL)isInSameWeek:(int64_t)time1 time2:(int64_t)time2;

/**
 是否属于同一月
 
 @param time1 time1
 @param time2 time2
 @return 同一月为真，否则为假
 */
+ (BOOL)isInSameMonth:(int64_t)time1 time2:(int64_t)time2;

/**
 * @method
 *
 * @brief 获取当前时间之后若干月之后的时间
 * @param months       月数
 * @return    NSDate
 */
+ (NSDate *)latterDateWithMonths:(NSInteger)months;

//获取某一时间之后几个月的时间
+ (NSDate *)latterDateWithDate:(NSDate *)date months:(NSInteger)months;

/**
 * @method
 *
 * @brief 获取当前时间之后若干天之后的时间
 * @param day       天数
 * @return    NSDate
 */
+ (NSDate *)latterDateWithDays:(NSInteger)days;

//获取某一时间之后几天的时间
+ (NSDate *)latterDateWithDate:(NSDate *)date days:(NSInteger)days;

/**
 * @method
 *
 * @brief 获取当前时间之后若干年之后的时间
 * @param years       年数
 * @return    NSDate
 */
+ (NSDate *)latterDateWithYears:(NSInteger)years;

//获取某一时间之后几年的时间
+ (NSDate *)latterDateWithDate:(NSDate *)date years:(NSInteger)years;


/**
 * @method
 *
 * @brief 获取两个日期之间的天数
 * @param fromDate       起始日期
 * @param toDate         终止日期
 * @return    总天数
 */
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;


/**
 * @method
 *
 * @brief 获取从现在开始几个月内的天数
 * @param months       月份数
 * @return    总天数
 */
+ (NSInteger)numberOfDaysFromNowWithMonths:(NSInteger)months;

@end
