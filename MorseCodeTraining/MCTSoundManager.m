//
//  MCTSoundManager.m
//  MorseCodeTraining
//
//  参考:
//  https://github.com/nicklockwood/SoundManager
//
//  Created by Suzuki Kouhei on 2014/02/01.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTSoundManager.h"

#import "MCTMorseSound.h"

NSString *const MCTSoundDidFinishPlayingNotification = @"MCTSoundDidFinishPlayingNotification";

#pragma mark - MCTSound

typedef void (^MCTSoundCompletionHandler)(BOOL didFinish);

@interface MCTSound : NSObject <AVAudioPlayerDelegate>

@property (nonatomic, readonly) NSData *soundData;
@property (nonatomic, readonly, getter = isPlaying) BOOL playing;
@property (nonatomic, getter = isLooping) BOOL looping;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval currentTime;
@property (nonatomic, copy) MCTSoundCompletionHandler completionHandler;
@property (nonatomic, strong) MCTSound *selfReference;
@property (nonatomic, strong) AVAudioPlayer *sound;

+ (MCTSound *)soundWithString:(NSString *)string;
- (MCTSound *)initWithString:(NSString *)string;
+ (MCTSound *)soundWithSoundData:(NSData *)soundData;
- (MCTSound *)initWithSoundData:(NSData *)soundData;

- (void)play;
- (void)pause;
- (void)stop;
- (void)prepareToPlay;

@end

@implementation MCTSound

+ (MCTSound *)soundWithString:(NSString *)string
{
    return [[self alloc] initWithString:string];
}

+ (MCTSound *)soundWithSoundData:(NSData *)soundData
{
    return [[self alloc] initWithSoundData:soundData];
}

- (MCTSound *)initWithString:(__unused NSString *)string
{
    NSData *soundData = [[MCTMorseSound sharedSound] soundDataWithString:string];
    return [self initWithSoundData:soundData];
}

- (MCTSound *)initWithSoundData:(NSData *)soundData
{
    if ((self = [super init])) {
        _soundData = soundData;

        NSError *error = nil;
        _sound = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
        if (error) NSLog(@"%@", error);
    }
    return self;
}

- (void)prepareToPlay
{
    //avoid overhead from repeated calls
    static BOOL prepared = NO;
    if (prepared) return;
    prepared = YES;

    [AVAudioSession sharedInstance];
    [_sound prepareToPlay];
}

- (NSTimeInterval)duration
{
    return [_sound duration];
}

- (NSTimeInterval)currentTime
{
    return [_sound currentTime];
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    [_sound setCurrentTime:currentTime];
}

- (BOOL)isLooping
{
    return [_sound numberOfLoops] == -1;
}

- (void)setLooping:(BOOL)looping
{
    [_sound setNumberOfLoops:looping? -1: 0];
}

- (BOOL)isPlaying
{
    return [_sound isPlaying];
}

- (void)play
{
    if (!self.playing) {
        self.selfReference = self;
        [_sound setDelegate:self];
        [_sound play];
    }
}

- (void)pause
{
    if (self.playing) {
        [_sound pause];
    }
}

- (void)stop
{
    if (self.playing) {
        [_sound stop];
        if (_completionHandler) _completionHandler(NO);
        [[NSNotificationCenter defaultCenter] postNotificationName:MCTSoundDidFinishPlayingNotification object:self];
        [self performSelector:@selector(setSelfReference:) withObject:nil afterDelay:0.0];
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(__unused AVAudioPlayer *)player successfully:(__unused BOOL)finishedPlaying
{
    if (_completionHandler) _completionHandler(NO);
    [[NSNotificationCenter defaultCenter] postNotificationName:MCTSoundDidFinishPlayingNotification object:self];
    [self performSelector:@selector(setSelfReference:) withObject:nil afterDelay:0.0];
}

@end


#pragma mark - MCTSoundManager

@interface MCTSoundManager ()

@property (nonatomic, strong) MCTSound *currentSound;

@end

@implementation MCTSoundManager

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initSharedInstance
{
    if (self = [super init]) {
        _loopingSound = NO;

        // バックグラウンでの再生を有効にする
        self.allowsBackgroundSound = YES;

        // 電話等で途切れた場合の通知
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:nil];

        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    return self;
}

+ (MCTSoundManager *)sharedManager
{
    static MCTSoundManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MCTSoundManager alloc] initSharedInstance];
    });
    return sharedInstance;
}

- (void)setAllowsBackgroundSound:(BOOL)allow
{
    if (_allowsBackgroundSound != allow) {
        _allowsBackgroundSound = allow;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *error = nil;
        [session setCategory:AVAudioSessionCategoryPlayback error:&error];
        if (error) NSLog(@"%@", error);
    }
}

- (void)playSound:(id)soundOrString
{
    MCTSound *sound = [soundOrString isKindOfClass:[MCTSound class]] ? soundOrString : [MCTSound soundWithString:soundOrString];
    [sound prepareToPlay];
    if (![sound.soundData isEqual:_currentSound.soundData]) {
        if (self.playingSound) {
            [_currentSound stop];
        }
        self.currentSound = sound;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(MCTSoundFinished:)
                                                     name:MCTSoundDidFinishPlayingNotification
                                                   object:sound];
        _currentSound.looping = self.loopingSound;
        [_currentSound play];
    }
}

- (void)playOrPauseSound
{
    if (_currentSound.playing) {
        [_currentSound pause];
    } else {
        [_currentSound play];
    }
}

- (void)stopSound
{
    [_currentSound stop];
    self.currentSound = nil;
}

- (BOOL)isPlayingSound
{
    return _currentSound && _currentSound.playing;
}

- (void)MCTSoundFinished:(NSNotification *)notification
{
    MCTSound *sound = [notification object];
    if (sound == _currentSound) {
        self.currentSound = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MCTSoundDidFinishPlayingNotification
                                                      object:sound];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification of AVAudioSession interruption

- (void)handleInterruption:(NSNotification *)notification
{
    NSUInteger reason = [notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
    switch ((AVAudioSessionInterruptionType)reason) {
        case AVAudioSessionInterruptionTypeBegan:
            NSLog(@"Interruption began");
            break;
        case AVAudioSessionInterruptionTypeEnded:
            NSLog(@"Interruption ended");
            break;
    }
}

#pragma mark - Handler of RemoteControlReceived

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch ((UIEventSubtype)receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlTogglePlayPause:
                NSLog(@"Remote control - Play or Pause");
                [self playOrPauseSound];
                break;
            case UIEventSubtypeRemoteControlStop:
                NSLog(@"Remote control - Stop");
                [self stopSound];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"Remote control - Next");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"Remote control - Previous");
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                NSLog(@"Remote control - Begin seeking");
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
            case UIEventSubtypeRemoteControlEndSeekingForward:
                NSLog(@"Remote control - End seeking");
                break;
            case UIEventSubtypeNone:
            case UIEventSubtypeMotionShake:
                break;
        }
    }
}

#pragma mark - Wpm and Frequency

- (void)setWpm:(NSInteger)wpm
{
    [MCTMorseSound sharedSound].wpm = wpm;
}

- (void)setFrequency:(NSInteger)frequency
{

    [MCTMorseSound sharedSound].frequency = frequency;
}


@end