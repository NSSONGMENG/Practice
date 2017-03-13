//
//  UIImage+Zip.h
//  nav
//
//  Created by songmeng on 15/11/7.
//  Copyright © 2015年 erlinyou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 不经解压直接读取压缩包中的图片
 压缩的图片格式为jpeg
 */
@interface UIImage (Zip)

+(UIImage *)imageNamed:(NSString *)name inZip:(NSString *)zip;
+(UIImage *)imageWithFileInZip:(NSString *)fileInZip;
+(UIImage *)rectImageWithFileInZip:(NSString *)fileInZip;
+(UIImage *)imageWithNameOrFilePath:(NSString *)nameOrFilePath;
+(BOOL)existImageWithFileInZip:(NSString *)zipPath;

/**
 裁剪成正方形
 
 @param filePath 文件路径
 @param width 目标尺寸
 width > 0，根据width进行压缩
 width <= 0,根据原图尺寸最小值进行剪切
 @return 目标image obj（jpeg）
 */
+(UIImage *)imageWithFileInZip:(NSString *)filePath aimWidth:(NSInteger)width __deprecated_msg("如果对图片尺寸大小没有要求，请使用‘rectImageWithFileInZip:’替代");

/**
 裁剪成正方形
 根据原图尺寸最小值进行剪切
 
 @param image 要裁剪的图片
 @return 目标image obj（jpeg）
 */
+(UIImage *)rectImageWithImage:(UIImage *)image;

/** 指定尺寸压缩 */

/**
 指定尺寸裁剪
 
 @param image 要裁剪的图片
 @param newSize 目标尺寸
 @return 目标image obj（jpeg）
 */
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 图片尺寸不变，压缩到指定大小
 
 @param image 要压缩的图片
 @param length 目标占用空间大小，单位：字节（b）
 @param accuracy 压缩控制误差范围（＋／－）
 @param maxCircleNum 最大循环压缩次数
 @return 目标image obj（jpeg）
 */
+ (NSData *)compressImageWithImage:(UIImage *)image aimLength:(NSInteger)length accurancyOfLength:(NSInteger)accuracy maxCircleNum:(int)maxCircleNum;

/**
 压缩图片质量
 推荐使用个方法对图片进行压缩
 
 @param image 要压缩的图片
 @param aimWidth （宽高最大值）
 @param aimLength 目标大小，单位：字节（b）
 @param accuracyOfLength 压缩控制误差范围(+ / -)
 @return 目标图片data
 */
+ (NSData *)compressImageWithImage:(UIImage *)image aimWidth:(CGFloat)width aimLength:(NSInteger)length accuracyOfLength:(NSInteger)accuracy;

@end
