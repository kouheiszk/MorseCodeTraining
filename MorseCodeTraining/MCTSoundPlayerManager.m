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

#import "MCTSoundPlayerManager.h"

#import <MediaPlayer/MediaPlayer.h>

NSString *const MCTSoundDidFinishPlayingNotification = @"MCTSoundDidFinishPlayingNotification";

#pragma mark - MCTSound interface

@interface MCTSound() <AVAudioPlayerDelegate>

@property (nonatomic, assign) CGFloat startVolume;
@property (nonatomic, assign) CGFloat targetVolume;
@property (nonatomic, assign) NSTimeInterval fadeTime;
@property (nonatomic, assign) NSTimeInterval fadeStart;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) MCTSound *selfReference;
@property (nonatomic, strong) AVAudioPlayer *soundPlayer;

- (void)prepareToPlay;

@end

#pragma mark - MCTSound implementation

@implementation MCTSound

+ (MCTSound *)soundWithSoundData:(NSData *)soundData
{
    return [[MCTSound alloc] initWithSoundData:soundData];
}

- (MCTSound *)initWithSoundData:(NSData *)soundData
{
    if (self = [super init]) {
        _soundData = soundData;
        _baseVolume = 1.0f;

        _soundPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:NULL];
        self.volume = 1.0f;
    }
    return self;
}

- (void)prepareToPlay
{
    // avoid overhead from repeated calls
    static BOOL prepared = NO;
    if (prepared) return;
    prepared = YES;

    [AVAudioSession sharedInstance];
    [_soundPlayer prepareToPlay];
}

- (void)setbaseVolume:(float)baseVolume
{
    baseVolume = fminf(1.0f, fmaxf(0.0f, baseVolume));

    if (_baseVolume != baseVolume) {
        float previousVolume = self.volume;
        _baseVolume = baseVolume;
        self.volume = previousVolume;
    }
}

- (float)volume
{
    if (_timer) {
        return _targetVolume / _baseVolume;
    } else {
        return [_soundPlayer volume] / _baseVolume;
    }
}

- (void)setVolume:(float)volume
{
    volume = fminf(1.0f, fmaxf(0.0f, volume));

    if (_timer) {
        _targetVolume = volume * _baseVolume;
    } else {
        [_soundPlayer setVolume:volume * _baseVolume];
    }
}

- (float)pan
{
    return [_soundPlayer pan];
}

- (void)setPan:(float)pan
{
    [_soundPlayer setPan:pan];
}

- (NSTimeInterval)duration
{
    return [_soundPlayer duration];
}

- (NSTimeInterval)currentTime
{
    return [_soundPlayer currentTime];
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    [_soundPlayer setCurrentTime:currentTime];
}

- (BOOL)isLooping
{
    return [_soundPlayer numberOfLoops] == -1;
}

- (void)setLooping:(BOOL)looping
{
    [_soundPlayer setNumberOfLoops:looping? -1: 0];
}

- (BOOL)isPlaying
{
    return [_soundPlayer isPlaying];
}

- (void)play
{
    if (!self.playing) {
        self.selfReference = self;
        [_soundPlayer setDelegate:self];
        [_soundPlayer play];
    }
}

- (void)pause
{
    if (self.playing) {
        [_soundPlayer pause];
    }
}

- (void)stop
{
    if (self.playing) {
        //stop playing
        [_soundPlayer stop];

        //stop timer
        [_timer invalidate];
        self.timer = nil;

        //fire events
        if (_completionHandler) _completionHandler(NO);
        [[NSNotificationCenter defaultCenter] postNotificationName:MCTSoundDidFinishPlayingNotification object:self];

        //set to nil on next runloop update so sound is not released unexpectedly
        [self performSelector:@selector(setSelfReference:) withObject:nil afterDelay:0.0];
    }
}

- (void)audioPlayerDidFinishPlaying:(__unused AVAudioPlayer *)player successfully:(__unused BOOL)finishedPlaying
{
    //stop timer
    [_timer invalidate];
    self.timer = nil;

    //fire events
    if (_completionHandler) _completionHandler(NO);
    [[NSNotificationCenter defaultCenter] postNotificationName:MCTSoundDidFinishPlayingNotification object:self];

    //set to nil on next runloop update so sound is not released unexpectedly
    [self performSelector:@selector(setSelfReference:) withObject:nil afterDelay:0.0];
}

- (void)dealloc
{
    [_timer invalidate];
}

@end

#pragma mark - MCTSoundManager interface

@interface MCTSoundPlayerManager ()

@property (nonatomic, readwrite) BOOL playingSound;
@property (nonatomic, strong) MCTSound *currentSound;

@end

#pragma mark - MCTSoundManager implementation

@implementation MCTSoundPlayerManager

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initSharedInstance
{
    if (self = [super init]) {
        _soundVolume = 1.0f;
        _soundFadeDuration = 1.0;

        // バックグラウンドでも、再生を続けるために、AVAudioSessionをAVAudioSessionCategoryPlaybackに
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
        [session setActive:YES error:nil];

        // 電話等で途切れた場合の通知
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:nil];

        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    return self;
}

+ (MCTSoundPlayerManager *)sharedManager
{
    static MCTSoundPlayerManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MCTSoundPlayerManager alloc] initSharedInstance];
    });
    return sharedInstance;
}

- (void)setSoundVolume:(float)newVolume
{
    _soundVolume = newVolume;
    _currentSound.volume = _soundVolume;
}

- (void)prepareToPlayWithSound:(id)soundOrSoundData
{
    MCTSound *sound = [soundOrSoundData isKindOfClass:[MCTSound class]]? soundOrSoundData: [MCTSound soundWithSoundData:soundOrSoundData];
    [sound prepareToPlay];
}

- (void)playSound:(id)soundOrSoundData looping:(BOOL)looping
{
    MCTSound *sound = [soundOrSoundData isKindOfClass:[MCTSound class]]? soundOrSoundData: [MCTSound soundWithSoundData:soundOrSoundData];
    if (![sound.soundData isEqual:_currentSound.soundData]) {
        if (_currentSound && _currentSound.playing) {
            [self stopSound];
        }
        self.currentSound = sound;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(soundFinished:)
                                                     name:MCTSoundDidFinishPlayingNotification
                                                   object:sound];
        _currentSound.looping = looping;
        _currentSound.volume = _soundVolume;
        [_currentSound play];
    }

}

- (void)playSound:(id)soundOrSoundData
{
    [self playSound:soundOrSoundData looping:YES];
}

- (void)playSound
{
    [_currentSound play];
}

- (void)pauseSound
{
    [_currentSound pause];
}

- (void)playOrPauseSound
{
    if (self.pausingSound) {
        [self playSound];
    }
    else {
        [self pauseSound];
    }
}

- (void)stopSound
{
    [_currentSound stop];
    self.currentSound = nil;
}

- (BOOL)isPlayingSound
{
    return _currentSound != nil;
}

- (BOOL)isPausingSound
{
    return _currentSound != nil && !_currentSound.playing;
}

- (void)soundFinished:(NSNotification *)notification
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
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

#pragma mark - Notification of AVAudioSession interruption

- (void)handleInterruption:(NSNotification *)notification
{
    NSUInteger reason = [notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
    switch ((AVAudioSessionInterruptionType)reason) {
        case AVAudioSessionInterruptionTypeBegan:
            self.playingSound = NO;
            [self pauseSound];
            NSLog(@"Interruption began");
            break;
        case AVAudioSessionInterruptionTypeEnded:
            [self playSound];
            NSLog(@"Interruption ended");
            break;
    }
}

#pragma mark - RemoteControlReceived delegate

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch ((UIEventSubtype)receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self playOrPauseSound];
                break;
            case UIEventSubtypeRemoteControlStop:
                [self stopSound];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
            case UIEventSubtypeRemoteControlPreviousTrack:
                // TODO 別の曲を流す
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                // TODO シークバーが触られたときの処理
            case UIEventSubtypeRemoteControlEndSeekingBackward:
            case UIEventSubtypeRemoteControlEndSeekingForward:
                // TODO シークバーが触られたときの処理
                break;
            case UIEventSubtypeNone:
            case UIEventSubtypeMotionShake:
                break;
        }
    }
}

@end
