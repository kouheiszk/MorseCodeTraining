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

NSString *const MCTSoundDidFinishPlayingNotification = @"MCTSoundDidFinishPlayingNotification";

#pragma mark - MCTSound interface

@interface MCTSound() <AVAudioPlayerDelegate>

@property (nonatomic, assign) float startVolume;
@property (nonatomic, assign) float targetVolume;
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

        //play sound
        [_soundPlayer play];
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

- (void)fadeTo:(float)volume duration:(NSTimeInterval)duration
{
    _startVolume = [_soundPlayer volume];
    _targetVolume = volume * _baseVolume;
    _fadeTime = duration;
    _fadeStart = [[NSDate date] timeIntervalSinceReferenceDate];
    if (_timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                      target:self
                                                    selector:@selector(tick)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)fadeIn:(NSTimeInterval)duration
{
    [_soundPlayer setVolume:0.0f];
    [self fadeTo:1.0f duration:duration];
}

- (void)fadeOut:(NSTimeInterval)duration
{
    [self fadeTo:0.0f duration:duration];
}

- (void)tick
{
    NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
    float delta = (now - _fadeStart)/_fadeTime * (_targetVolume - _startVolume);
    [_soundPlayer setVolume:(_startVolume + delta) * _baseVolume];
    if ((delta > 0.0f && [_soundPlayer volume] >= _targetVolume) ||
        (delta < 0.0f && [_soundPlayer volume] <= _targetVolume))
    {
        [_soundPlayer setVolume:_targetVolume * _baseVolume];
        [_timer invalidate];
        self.timer = nil;
        if ([_soundPlayer volume] == 0.0f)
        {
            [self stop];
        }
    }
}

- (void)dealloc
{
    [_timer invalidate];
}

@end

#pragma mark - MCTSoundManager interface

@interface MCTSoundPlayerManager ()

@property (nonatomic, strong) MCTSound *currentSound;

@end

#pragma mark - MCTSoundManager implementation

@implementation MCTSoundPlayerManager

static MCTSoundPlayerManager *sharedInstance = nil;

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
    }
    return self;
}

+ (MCTSoundPlayerManager *)sharedManager
{
    static MCTSoundPlayerManager* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MCTSoundPlayerManager alloc] initSharedInstance];
    });
    return sharedInstance;
}

- (void)setAllowsBackgroundSound:(BOOL)allow
{
    if (_allowsBackgroundSound != allow) {
        _allowsBackgroundSound = allow;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:allow? AVAudioSessionCategoryAmbient: AVAudioSessionCategorySoloAmbient error:NULL];
    }
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

- (void)playSound:(id)soundOrSoundData looping:(BOOL)looping fadeIn:(BOOL)fadeIn
{
    MCTSound *sound = [soundOrSoundData isKindOfClass:[MCTSound class]]? soundOrSoundData: [MCTSound soundWithSoundData:soundOrSoundData];
    if (![sound.soundData isEqual:_currentSound.soundData]) {
        if (_currentSound && _currentSound.playing)
        {
            [_currentSound fadeOut:_soundFadeDuration];
        }
        self.currentSound = sound;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(soundFinished:)
                                                     name:MCTSoundDidFinishPlayingNotification
                                                   object:sound];
        _currentSound.looping = looping;
        _currentSound.volume = fadeIn? 0.0f: _soundVolume;
        [_currentSound play];
        if (fadeIn)
        {
            [_currentSound fadeTo:_soundVolume duration:_soundFadeDuration];
        }
    }
}

- (void)playSound:(id)soundOrSoundData looping:(BOOL)looping
{
    [self playSound:soundOrSoundData looping:looping fadeIn:YES];
}

- (void)playSound:(id)soundOrSoundData
{
    [self playSound:soundOrSoundData looping:YES fadeIn:YES];
}

- (void)stopSound:(BOOL)fadeOut
{
    if (fadeOut) {
        [_currentSound fadeOut:_soundFadeDuration];
    }
    else {
        [_currentSound stop];
    }
    self.currentSound = nil;
}

- (void)stopSound
{
    [self stopSound:YES];
}

- (BOOL)isPlayingSound
{
    return _currentSound != nil;
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
}

@end
