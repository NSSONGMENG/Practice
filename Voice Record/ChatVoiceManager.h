//
//  ChatVoiceManager.h
//  Boobuz
//
//  Created by songmeng on 16/6/16.
//  Copyright © 2016年 erlinyou.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessageModel.h"

extern  NSString    * const ChatVoiceManagerWillPlayAudioNotification;
extern  NSString    * const ChatVoiceManagerPlayerItemKey;
extern  NSString    * const ChatVoiceManagerMsgIdKey;

extern  NSString    * const ChatVoiceManagerErrorKey;
extern  NSString    * const ChatVoiceManagerAudioUrlKey;
extern  NSString    * const ChatVoiceManagerTimeIntervalKey;

extern  NSString    * const ChatVoiceManagerTimeTooShortResponse;

/**
 实现录音和音频播放功能
 录制的音频文件格式为.wav，因为安卓不支持wav，ios不支持amr，而且amr文件拥有更小存储空间的优势
 所以发送和接收的语音文件都是amr文件，聊天中录音文件通过VoiceConvert提供的方法转换成.amr文件发送
 接收到的amr语音需要通过VoiceConvert提供的方法转换成.wav才能播放
 */
@interface ChatVoiceManager : NSObject

//返回实时录音信息
/** 返回音量大小voiceValue，和已录制时间 */
@property (nonatomic, copy) void (^callBackRecordInfo)(float voiceValue, CGFloat recordingTime);

//声音播放完成
@property (nonatomic, copy) void (^voiceDidFinishPlaying)() __deprecated_msg("已弃用，请在需要监听语音播放完成的地方添加通知AVPlayerItemDidPlayToEndTimeNotification");

/** 正在录音 */
@property (nonatomic, readonly) BOOL  isRecording;

+ (instancetype) shareInstance;

/**  返回音频保存路径 */
- (NSString *)getDataPath;

/** 开始录音 */
- (void)startRecord;

/** 放弃录音 */
- (void)stopRecord;

/**
 停止录音并返回资源信息
 资源信息字典
 */
- (NSDictionary *)stopRecordWithData;

/** 通过url播放音频，支持http链接和本地资源路径 */
- (void)playSoundWithURL:(NSString *)resourceURL __deprecated_msg("弃用，播放转发的语音消息可能会遇到两个cell同时出现播放动画的情况");

/** 通过url播放音频，支持http链接和本地资源路径混合 */
- (void)playSoundWithUrlArray:(NSArray <ChatMessageModel *>*)msgArr;

/** 停止播放音频 */
- (void)stopPlaying;

/** 停止音频监测，停止播放进程 */
- (void)clearSettings;

@end
