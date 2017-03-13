//
//  ChatVoiceManager.m
//  Boobuz
//
//  Created by songmeng on 16/6/16.
//  Copyright © 2016年 erlinyou.com. All rights reserved.
//

#import "ChatVoiceManager.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceConverter.h"
#import "ChatListModule.h"
#import "IChatDDAO.h"

NSString    * const ChatVoiceManagerWillPlayAudioNotification = @"ChatVoiceManagerWillPlayAudioNotification";
NSString    * const ChatVoiceManagerPlayerItemKey = @"ChatVoiceManagerPlayerItemKey";
NSString    * const ChatVoiceManagerMsgIdKey = @"ChatVoiceManagerMsgIdKey";

NSString    * const ChatVoiceManagerErrorKey = @"ChatVoiceManagerErrorKey";
NSString    * const ChatVoiceManagerAudioUrlKey = @"ChatVoiceManagerAudioUrlKey";
NSString    * const ChatVoiceManagerTimeIntervalKey = @"ChatVoiceManagerTimeIntervalKey";

NSString    * const ChatVoiceManagerTimeTooShortResponse = @"time is too short";

@interface ChatVoiceManager ()<AVAudioRecorderDelegate>{
    NSString    * _playName;
    AVQueuePlayer   * _queuePlayer; //播放器
    double      _lowPassResults;    //音量
}

@property (nonatomic, strong) AVAudioRecorder    * recoder;
@property (nonatomic, strong) AVAudioPlayer     * player;
@property (nonatomic, assign) CGFloat       volice; //音量大小
@property (nonatomic, copy)   NSString      * recordingTime;   //录音时间
@property (nonatomic, assign) CGFloat       voiceTimeInterval;
@property (nonatomic, strong) NSTimer       * timer;

@property (nonatomic, strong) NSArray   * audioMessages;

@end

@implementation ChatVoiceManager

static ChatVoiceManager * instance;
+ (instancetype) shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ChatVoiceManager new];
    });
    return  instance;
}

#pragma mark  - avaudioplayer delegate
- (void)audioPlayerDidFinishPlaying:(NSNotification *)notification{
    AVPlayerItem    * item = notification.object;
    __block NSInteger   index = 0;
    [_queuePlayer.items enumerateObjectsUsingBlock:^(AVPlayerItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AVURLAsset * playedAset = (AVURLAsset *)item.asset;
        if ([playedAset.URL.lastPathComponent isEqualToString:playedAset.URL.lastPathComponent]) {
            index = idx+1;
            *stop = YES;
        }
    }];
    
    if ([_queuePlayer.items count] <= index) {
        //播放完毕
        //关闭红外传感器
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        //解除对音乐播放资源的占用
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        
        [_audioMessages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ChatMessageModel    * msg = obj;
            if (![msg.isReaded boolValue]) {
                if (msg.chatType == chatType_chat) {
                    [[ChatListModule getInstance] updateChatMessage:@{KCHAT_ISREADED:@YES} messageId:msg.messageId];
                }
                else{
                    [[ChatListModule getInstance] updateMultiChats:@{KCHAT_ISREADED:@YES} messageId:msg.messageId];
                }
            }
            msg.isReaded = @YES;
            msg.audioIsPlaying = NO;
        }];
        
        //只在老聊天页的ChatCell中调用过
        if (self.voiceDidFinishPlaying) {
            self.voiceDidFinishPlaying();
        }
        _audioMessages = nil;
    }else{
        [_audioMessages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ChatMessageModel    * msg = obj;
            if (idx < index) {
                msg.isReaded = @YES;
                msg.audioIsPlaying = NO;
            }
            if (idx == index) {
                if (msg.chatType == chatType_chat) {
                    [[ChatListModule getInstance] updateChatMessage:@{KCHAT_ISREADED:@YES} messageId:msg.messageId];
                }
                else{
                    [[ChatListModule getInstance] updateMultiChats:@{KCHAT_ISREADED:@YES} messageId:msg.messageId];
                }
                msg.audioIsPlaying = YES;
            }
        }];
        ChatMessageModel    * msg = _audioMessages[index];
        if (msg && _queuePlayer.items[index]) {
            NSDictionary    * dic = @{
                                      ChatVoiceManagerMsgIdKey:msg.messageId,
                                      ChatVoiceManagerPlayerItemKey:_queuePlayer.items[index]
                                      };
            [[NSNotificationCenter defaultCenter] postNotificationName:ChatVoiceManagerWillPlayAudioNotification object:dic];
        }
    }
    
}

#pragma mark  - public method

//返回音频保存路径
- (NSString *)getDataPath{
    NSString    * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString    * path = [documentPath stringByAppendingPathComponent:@"chat/chatVoice"];
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!result) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:NULL];
    }
    return path;
}

- (void)startRecord{
    if ([self.player isPlaying]) {
        [self.player stop];
    }
    _voiceTimeInterval = 0;
    //音频保存路径
    NSString *docDir = [self getDataPath];
    NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
    _playName = [NSString stringWithFormat:@"%@/%ld_%u.wav",docDir,(long)timeInterval*1000,arc4random()%100];
    NSError * error;
    
    //初始化录音器
    self.recoder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:_playName] settings:[VoiceConverter GetAudioRecorderSettingDict] error:&error];
    
    //准备录音
    if ([self.recoder prepareToRecord]){
        
        _recoder.meteringEnabled = YES;
        _recoder.delegate = self;
        //启动定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(levelTimer:) userInfo:nil repeats:YES];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        //开始录音
        [_recoder record];
    }
}

//放弃录音
- (void)stopRecord{
    [self stop];
    if ([self isRecording]) {
        NSError * error;
        [[NSFileManager defaultManager] removeItemAtPath:_playName error:&error];
        if(error){
            DLog(@" ---  error : %@ ---- ",error);
        }
    }
}


/**
 停止录音
 
 @return 音频信息
 */
- (NSDictionary *)stopRecordWithData{
    [self stop];
    NSString    * amrPath = [_playName copy];
    if (_voiceTimeInterval <= 1.0) {
        return @{
                 ChatVoiceManagerErrorKey : ChatVoiceManagerTimeTooShortResponse
                 };
    }
    amrPath = [amrPath stringByReplacingOccurrencesOfString:@".wav" withString:@".amr"];
    if ([VoiceConverter ConvertWavToAmr:_playName amrSavePath:amrPath]) {
        NSInteger   time = (NSInteger)_voiceTimeInterval;
        [[NSFileManager defaultManager] removeItemAtPath:_playName error:NULL];
        return @{
                 ChatVoiceManagerAudioUrlKey: amrPath ,
                 ChatVoiceManagerTimeIntervalKey : @(time)
                 };
    }
    DLog(@" -- 转换失败 amr : %@ -- ",amrPath);
    return @{};
}

//录音停止
- (void)stop{
    [_timer invalidate];
    if (self.recoder){
        [self.recoder stop];
    }
    
    //解除对播放资源的占用
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}


//通过url播放音频
- (void)playSoundWithURL:(NSString *)resourceURL{
    [self addNotification];
    
    //开启红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    AVAudioSession  * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    NSString    * amrPath = [resourceURL copy];
    amrPath = [amrPath stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:amrPath]){
        [VoiceConverter ConvertAmrToWav:resourceURL wavSavePath:amrPath];
    }
    
    //初始化播放器
    _queuePlayer = nil;
    NSURL   * url;
    if ([amrPath containsString:@"http://"]){
        url = [NSURL URLWithString:amrPath];
    }else{
        url = [NSURL fileURLWithPath:amrPath];
    }
    AVPlayerItem    *item = [[AVPlayerItem alloc] initWithURL:url];
    _queuePlayer = [AVQueuePlayer queuePlayerWithItems:@[item]];
    
    NSDictionary    * dic = @{
                              ChatVoiceManagerMsgIdKey:@"",
                              ChatVoiceManagerPlayerItemKey:item
                              };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ChatVoiceManagerWillPlayAudioNotification object:dic];
    [_queuePlayer play];
    
    [self distanceChanged:nil];
}

//初始化播放器
- (void)playSoundWithUrlArray:(NSArray <ChatMessageModel *>*)msgArr{
    _audioMessages = msgArr;
    [self addNotification];
    //开启红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    AVAudioSession  * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    NSMutableArray  * items = [NSMutableArray array];
    __block NSMutableArray  * urls = [NSMutableArray array];
    [msgArr enumerateObjectsUsingBlock:^(ChatMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString    * path = [obj getFilePath];
        if ([path containsString:@".amr"]) {
            NSString * aimPath = [path stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:aimPath]){
                //语音格式转换
                [VoiceConverter ConvertAmrToWav:path wavSavePath:aimPath];
            }
            path = aimPath;
        }
        [urls addObject:path];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        }
    }];
    for (int i = 0; i < [urls count]; i ++) {
        NSString    * str = urls[i];
        NSURL   * url;
        if ([str containsString:@"http://"]){
            url = [NSURL URLWithString:str];
        }else{
            url = [NSURL fileURLWithPath:str];
        }
        
        AVPlayerItem    * item = [[AVPlayerItem alloc] initWithURL:url];
        [items addObject:item];
    }
    _queuePlayer = nil;
    _queuePlayer = [[AVQueuePlayer alloc] initWithItems:[items copy]];
    ChatMessageModel    * msg = [msgArr firstObject];
    NSDictionary    * dic = @{ChatVoiceManagerMsgIdKey:msg.messageId,
                              ChatVoiceManagerPlayerItemKey:[items firstObject]
                              };
    [[NSNotificationCenter defaultCenter] postNotificationName:ChatVoiceManagerWillPlayAudioNotification object:dic];
    [_queuePlayer play];
    
    [self distanceChanged:nil];
}

//停止播放
- (void)stopPlaying{
    if (_queuePlayer) {
        [_queuePlayer pause];
        [_queuePlayer removeAllItems];
    }
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

- (void)clearSettings{
    [_timer invalidate];
    [_player stop];
    [_queuePlayer pause];
    [_recoder stop];
}


#pragma mark  - provate method
//播放语音时添加通知
- (void)addNotification{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //距离传感器，探测距离远近变化
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(distanceChanged:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
        //播放完成监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(audioPlayerDidFinishPlaying:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
    });
}

-(void)levelTimer:(NSTimer*)timer{
    //_playName不正确会导致得录音失败，监测不到音量
    _voiceTimeInterval += 0.1;
    [_recoder updateMeters];
    float power= [_recoder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    _lowPassResults = pow(10,(0.05*power));
    if (self.callBackRecordInfo) {
        self.callBackRecordInfo(_lowPassResults,_voiceTimeInterval);
    }
}

//判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                    message:LocalizedString(@"sEnableMic")
                                                   delegate:nil
                                          cancelButtonTitle:LocalizedString(@"sCancel")
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    
    return bCanRecord;
}


#pragma mark  - notification
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    _voiceTimeInterval = 0.f;
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

- (void)distanceChanged:(NSNotification *)notification{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES){
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


- (BOOL)isRecording{
    if (_recoder) {
        return [_recoder isRecording];
    }
    return NO;
}

@end
