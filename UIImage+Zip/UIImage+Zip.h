//
//  UIImage+Zip.h
//  nav
//
//  Created by SoMe on 15/11/7.
//  Copyright © 2015年 erlinyou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Zip)

+(UIImage *)imageNamed:(NSString *)name inZip:(NSString *)zip;
+(UIImage *)imageWithFileInZip:(NSString *)fileInZip;
+(UIImage *)imageWithNameOrFilePath:(NSString *)nameOrFilePath;

/** 裁剪成正方形 
 *  width > 0，根据width进行压缩
 *  width <= 0,根据原图尺寸最小值进行剪切
 */
+(UIImage *)imageWithFileInZip:(NSString *)filePath aimWidth:(NSInteger)width;

/** 裁剪成正方形
 *  width > 0，根据width进行压缩
 *  width <= 0,根据原图尺寸最小值进行压缩
 */
+(UIImage *)imageWithImage:(UIImage *)image aimWidth:(NSInteger)width;

/** 裁剪成正方形
 *  根据原图尺寸最小值进行剪切
 */
+(UIImage *)rectImageWithImage:(UIImage *)image;

/** 指定尺寸压缩 */
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  质量不变，压缩到指定大小
 *  aimLength：目标大小      accurancyOfLength：压缩控制误差范围(+ / -)        maxCircleNum:最大循环次数
 */
+ (NSData *)compressImageWithImage:(UIImage *)image aimLength:(NSInteger)length accurancyOfLength:(NSInteger)accuracy maxCircleNum:(int)maxCircleNum;

/**
 *  压缩图片质量
 *  aimWidth:  （宽高最大值）
 *  aimLength: 目标大小，单位：字节（b）
 *  accuracyOfLength: 压缩控制误差范围(+ / -)
 *  推荐使用个方法对图片进行压缩
 */
+ (NSData *)compressImageWithImage:(UIImage *)image aimWidth:(CGFloat)width aimLength:(NSInteger)length accuracyOfLength:(NSInteger)accuracy;

@end
