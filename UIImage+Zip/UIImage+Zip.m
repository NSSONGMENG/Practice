//
//  UIImage+Zip.m
//  nav
//
//  Created by songmeng on 15/11/7.
//  Copyright © 2015年 erlinyou.com. All rights reserved.
//


#import "UIImage+Zip.h"
#import <zipzap/ZipZap.h>

@implementation UIImage (Zip)

NSMutableDictionary *zipDict;

+(void)load {
    zipDict = [[NSMutableDictionary alloc] init];
}

+(BOOL)existImageWithFileInZip:(NSString *)zipPath{
    if (!ISNOTNULL(zipPath) || [zipPath isEqualToString:@""] || [zipPath isEqualToString:@"(null)"]) {
        return NO;
    }
    
    //重新拼接路径
    NSString *documentStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    NSArray * arr = [zipPath componentsSeparatedByString:@"/"];
    NSMutableArray  * pathArr = [NSMutableArray array];
    NSInteger   docIndex = [arr indexOfObject:@"Documents"];
    for (NSInteger i = docIndex+1; i < [arr count]-1; i++) {
        [pathArr addObject:arr[i]];
    }
    
    NSMutableString    * path = [documentStr mutableCopy];
    for (int i = 0; i < [pathArr count]; i++) {
        [path appendFormat:@"/%@",pathArr[i]];
    }
    [path appendString:@".zip"];
    NSString    * fileName = [arr lastObject];
    //
    NSError  * error;
    if (!zipDict[path]) {
        ZZArchive *archive = [ZZArchive archiveWithURL:[NSURL fileURLWithPath:path] error:&error];
        if (error) {
            return NO;
        }
        [zipDict setObject:archive forKey:path];
    }
    
    ZZArchive *archive = zipDict[path];
    for (ZZArchiveEntry * ectry in archive.entries) {
        if ([ectry.fileName isEqualToString:fileName]) {
            return YES;
        }
    }
    return NO;
}

+(UIImage *)imageNamed:(NSString *)name inZip:(NSString *)zip{
    __block NSError  * error;
    //    NSLog(@"%@ -- name %@",zip,name);
    if (!zipDict[zip]) {
        ZZArchive *archive = [ZZArchive archiveWithURL:[NSURL fileURLWithPath:zip] error:&error];
        if (error) {
            return nil;
        }
        [zipDict setObject:archive forKey:zip];
    }
    ZZArchive *archive = zipDict[zip];
    __block UIImage * img = nil;
    [archive.entries enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(ZZArchiveEntry * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString    * fileName = [[obj.fileName componentsSeparatedByString:@"/"] lastObject];
        if ([fileName isEqualToString:name]) {
            NSData * data = [obj newDataWithError:&error];
            if (error) {
                *stop = YES;
            }else{
                img = [UIImage imageWithData:data];
                *stop = YES;
            }
        }
    }];
    return img;
}

+(UIImage *)imageWithFileInZip:(NSString *)fileInZip
{
    if (!fileInZip || [fileInZip isKindOfClass:[NSNull class]] || [fileInZip isEqualToString:@""] || [fileInZip isEqualToString:@"(null)"]) {
        return nil;
    }
    
    //var/mobile/Containers/Data/Application/8E94BBA2-056C-4953-9922-74EC45F3A5A3/Documents/此路径每次启动都会变化,所以必须重新拼接。
    NSString *documentStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    NSArray * arr = [fileInZip componentsSeparatedByString:@"/"];
    NSMutableArray  * pathArr = [NSMutableArray array];
    NSInteger   docIndex = [arr indexOfObject:@"Documents"];
    for (NSInteger i = docIndex+1; i < [arr count]-1; i++) {
        [pathArr addObject:arr[i]];
    }
    
    NSMutableString    * zipPath = [documentStr mutableCopy];
    for (int i = 0; i < [pathArr count]; i++) {
        [zipPath appendFormat:@"/%@",pathArr[i]];
    }
    [zipPath appendString:@".zip"];
    UIImage *image = [UIImage imageNamed:[arr lastObject] inZip:zipPath];
    if (image){
        return image;
    }
    
    return [self imageWithContentsOfFile:fileInZip];
}

+(UIImage *)rectImageWithFileInZip:(NSString *)fileInZip{
    if (!ISNOTNULL(fileInZip) || [fileInZip isEqualToString:@""] || [fileInZip isEqualToString:@"(null)"]) {
        return nil;
    }
    
    UIImage * image = [UIImage imageWithFileInZip:fileInZip];
    if (image.size.width == image.size.height) {
        return image;
    }
    
    UIImage * rectImage = [UIImage rectImageWithImage:image];
    return rectImage;
}

+(UIImage *)imageWithNameOrFilePath:(NSString *)nameOrFilePath
{
    if (!ISNOTNULL(nameOrFilePath) || [nameOrFilePath isEqualToString:@""] || [nameOrFilePath isEqualToString:@"(null)"]) {
        return nil;
    }
    if ([nameOrFilePath rangeOfString:@"/var/mobile"].location==0) {
        return [UIImage imageWithFileInZip:nameOrFilePath];
    }
    else {
        return ImageByDayNightMode(nameOrFilePath);
    }
}

#pragma mark  - 尺寸压缩
//压缩成宽高均为width的矩形
+(UIImage *)imageWithFileInZip:(NSString *)filePath aimWidth:(NSInteger)width{
    UIImage * image = [self imageWithFileInZip:filePath];
    if (!image) {
        return nil;
    }
    return [self imageWithImage:image aimWidth:width];
}

//压缩成宽高均为width的矩形
+(UIImage *)imageWithImage:(UIImage *)image aimWidth:(NSInteger)width{
    if (!image) {
        return nil;
    }
    UIImage * newImage = [self rectImageWithImage:image];
    if (width > 0 && newImage.size.width > width) {
        return [self imageWithImage:newImage scaledToSize:CGSizeMake(width, width)];
    }
    return newImage;
}

//指定压缩尺寸
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    if (!image) {
        return nil;
    }
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//剪切成方形image
+(UIImage *)rectImageWithImage:(UIImage *)image{
    if (!image) {
        return nil;
    }
    
    if (image.size.width == image.size.height) {
        return image;
    }
    CGImageRef  image_cg = [image CGImage];
    CGSize      imageSize = CGSizeMake(CGImageGetWidth(image_cg), CGImageGetHeight(image_cg));
    
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    CGFloat width;
    CGPoint purePoint;
    if (imageWidth > imageHeight){
        width = imageHeight;
        purePoint = CGPointMake((imageWidth - width) / 2, 0);
    }else{
        width = imageWidth;
        purePoint = CGPointMake(0, (imageHeight - width) / 2);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(purePoint.x, purePoint.y, width, width));
    UIImage * thumbImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbImage;
    
}

#pragma mark  - 质量压缩
/**
 图片尺寸不变，压缩到指定大小
 
 @param image 要压缩的图片
 @param length 目标占用寸尺空间大小
 @param accuracy 压缩控制误差范围（＋／－）
 @param maxCircleNum 最大循环裁剪次数
 @return 目标image obj
 */
+ (NSData *)compressImageWithImage:(UIImage *)image aimLength:(NSInteger)length accurancyOfLength:(NSInteger)accuracy maxCircleNum:(int)maxCircleNum{
    if (!image) {
        return nil;
    }
    NSData * imageData = UIImageJPEGRepresentation(image, 1);
    CGFloat scale = image.size.height/image.size.width;
    if (imageData.length <= length + accuracy) {
        return imageData;
    }else{
        //先对质量进行0.99的压缩，再压缩尺寸
        NSData * imgData = UIImageJPEGRepresentation(image, 0.99);
        if (imgData.length <= length + accuracy) {
            return imgData;
        }else{
            UIImage * img = [UIImage imageWithData:imgData];
            int flag = 0;
            NSInteger maxWidth = img.size.width;
            NSInteger minWidth = 50;
            NSInteger midWidth = (maxWidth + minWidth)/2;
            if (flag == 0) {
                UIImage * newImage = [UIImage imageWithImage:img scaledToSize:CGSizeMake(minWidth, minWidth*scale)];
                NSData * data = UIImageJPEGRepresentation(newImage, 1);
                if ([data length] > length + accuracy) {
                    return data;
                }
            }
            
            while (1) {
                flag ++ ;
                UIImage * newImage = [UIImage imageWithImage:img scaledToSize:CGSizeMake(midWidth, midWidth*scale)];
                NSData * data = UIImageJPEGRepresentation(newImage, 1);
                NSInteger imageLength = data.length;
                if (flag >= maxCircleNum) {
                    return data;
                }
                
                if (imageLength > length + accuracy) {
                    maxWidth = midWidth;
                    midWidth = (minWidth + maxWidth)/2;
                    continue;
                }else if (imageLength < length - accuracy){
                    minWidth = midWidth;
                    midWidth = (minWidth + maxWidth)/2;
                    continue;
                }else{
                    return data;
                }
            }
        }
    }
}

/**
 *  压缩图片质量
 *  aimWidth:  （宽高最大值）
 *  aimLength: 目标大小，单位：字节（b）
 *  accuracyOfLength: 压缩控制误差范围(+ / -)
 */
+ (NSData *)compressImageWithImage:(UIImage *)image aimWidth:(CGFloat)width aimLength:(NSInteger)length accuracyOfLength:(NSInteger)accuracy{
    if (!image) {
        return nil;
    }
    CGFloat imgWidth = image.size.width;
    CGFloat imgHeight = image.size.height;
    CGSize  aimSize;
    if (width >= imgWidth) {
        aimSize = image.size;
    }else{
        aimSize = CGSizeMake(width, width*imgHeight/imgWidth);
    }
    UIImage * newImage = [UIImage imageWithImage:image scaledToSize:aimSize];
    
    NSData  * data = UIImageJPEGRepresentation(newImage, 1);
    NSInteger imageDataLen = [data length];
    
    if (imageDataLen <= length + accuracy) {
        return data;
    }else{
        NSData * imageData = UIImageJPEGRepresentation( newImage, 0.99);
        if (imageData.length < length + accuracy) {
            return imageData;
        }
        
        
        CGFloat maxQuality = 1.0;
        CGFloat minQuality = 0.0;
        int flag = 0;
        
        while (1) {
            @autoreleasepool {
                CGFloat midQuality = (maxQuality + minQuality)/2;
                
                if (flag >= 6) {
                    NSData * data = UIImageJPEGRepresentation(newImage, minQuality);
                    return data;
                }
                flag ++;
                
                NSData * imageData = UIImageJPEGRepresentation(newImage, midQuality);
                NSInteger len = imageData.length;
                
                if (len > length+accuracy) {
                    maxQuality = midQuality;
                    continue;
                }else if (len < length-accuracy){
                    minQuality = midQuality;
                    continue;
                }else{
                    return imageData;
                    break;
                }
            }
        }
    }
}

@end
