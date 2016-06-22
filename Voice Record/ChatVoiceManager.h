//
//  ChatVoiceManager.h
//  Boobuz
//
//  Created by songmeng on 16/6/16.
//  Copyright © 2016年 erlinyou.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TIME_TOO_SHORT  @"time is too short"

@interface ChatVoiceManager : NSObject

//返回实时录音信息
//返回音量大小voiceValue，和已录制时间
@property (nonatomic, copy) void (^callBackRecordInfo)(double voiceValue, CGFloat voiceTimeInterval);

//声音播放完成
@property (nonatomic, copy) void (^voiceDidFinishPlaying)();

+ (instancetype) shareInstance;

//获取音频保存地址
- (NSString *)getDataPath;

//开始录音
- (void)startRecord;

//结束录音
- (void)stopRecord;

//结束录音，返回音频路径
- (NSDictionary *)stopRecordWithData;

//播放音频
- (void)playSoundWithURL:(NSURL *)resourceURL;

@end
