//
//  ChatVoiceManager.m
//  Boobuz
//
//  Created by songmeng on 16/6/16.
//  Copyright © 2016年 erlinyou.com. All rights reserved.
//

#import "ChatVoiceManager.h"
#import <AVFoundation/AVFoundation.h>

@interface ChatVoiceManager ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>{
    NSString    * playName;
    NSTimer     * timer;
    //录音器
    AVAudioRecorder *recorder;
    //播放器
    AVAudioPlayer   * player;
    NSDictionary    * recorderSettingsDict;

    double lowPassResults;
    CGFloat     voiceTimeInterval;
}

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

- (void)startRecord{
    [self initRecorder];
    if ([self canRecord]) {
        NSError *error = nil;
        //必须真机上测试,模拟器上可能会崩溃
        recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:playName] settings:recorderSettingsDict error:&error];

        if (recorder) {
            recorder.meteringEnabled = YES;
            [recorder prepareToRecord];
            [recorder record];
            recorder.delegate = self;
            //启动定时器
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(levelTimer:) userInfo:nil repeats:YES];

        }else {
            int errorCode = CFSwapInt32HostToBig ([error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);

        }
    }

}

- (void)stopRecord{
    [self stop];

    NSError * error;
    [[NSFileManager defaultManager] removeItemAtPath:playName error:&error];
    if(error){
        NSLog(@" ---  error : %@ ---- ",error);
    }
}

- (void)stop{
    //录音停止
    [recorder stop];

    recorder = nil;
    //结束定时器
    [timer invalidate];
    timer = nil;
}

- (NSDictionary *)stopRecordWithData{
    [self stop];
    if (voiceTimeInterval < 1.0) {
        return @{@"error" : TIME_TOO_SHORT};
    }

    NSInteger   time = (NSInteger)voiceTimeInterval;
    return @{@"voiceURL" : playName , @"timeInterval" : @(time)};
}

- (void)playSoundWithURL:(NSURL *)resourceURL{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(distanceChanged:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
    });

    if (player && [player isPlaying]){
        [player stop];
    }

    NSError *playerError;
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    AVAudioSession  * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];

    //播放
    player = nil;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:resourceURL error:&playerError];
    player.delegate = self;
    if (player == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }else{
        [player play];
    }

    [self distanceChanged:nil];
}

- (void)initRecorder{
    voiceTimeInterval = 0;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
    }


    NSString *docDir = [self getDataPath];
    NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
    playName = [NSString stringWithFormat:@"%@/%ld.aac",docDir,(NSInteger)timeInterval];
    //录音设置
    recorderSettingsDict =[[NSDictionary alloc] initWithObjectsAndKeys:
                           @(kAudioFormatMPEG4AAC),AVFormatIDKey,
                           @44100.0,AVSampleRateKey,
                           @1,AVNumberOfChannelsKey,
                           @16,AVLinearPCMBitDepthKey,
                           @NO,AVLinearPCMIsBigEndianKey,
                           @NO,AVLinearPCMIsFloatKey,
                           @(AVAudioQualityHigh),AVEncoderAudioQualityKey,
                           nil];
}

- (NSString *)getDataPath{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString   * path = [docDir stringByAppendingString:@"/VoiceDir/"];
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!result) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:NULL];
    }
    return path;
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
                                                    message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                                   delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }

    return bCanRecord;
}

-(void)levelTimer:(NSTimer*)timer{
    //playName不正确会导致得录音失败，监测不到音量
    voiceTimeInterval += 0.1;
    //call to refresh meter values刷新平均和峰值功率,此计数是以对数刻度计量的,-160表示完全安静，0表示最大输入值
    [recorder updateMeters];
    lowPassResults = pow(10, (0.05 * [recorder averagePowerForChannel:0]));

    if (self.callBackRecordInfo) {
        self.callBackRecordInfo(lowPassResults,voiceTimeInterval);
    }
}

#pragma mark  -
#pragma mark  -------- notification --------
- (void)distanceChanged:(NSNotification *)notification{
    NSLog(@" notification ");
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


#pragma mark  -
#pragma mark  -------- delegate --------
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@" did finish recording");
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    if (self.voiceDidFinishPlaying) {
        self.voiceDidFinishPlaying();
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceProximityStateDidChangeNotification
                                                  object:nil];
}


@end
