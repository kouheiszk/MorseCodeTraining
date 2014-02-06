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
#import "MCTMorseSound.h"

NSString *const MCTSoundPlayerManagerDidFinishPlayingNotification = @"MCTSoundDidFinishPlayingNotification";

#pragma mark - MCTSoundManager interface

@interface MCTSoundPlayerManager ()

@property (nonatomic) BOOL shouldResume;
@property (nonatomic) NSMutableDictionary *artworks;
@property (nonatomic) AVAudioPlayer *player;

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
        self.looping = NO;

        // バックグラウンドでも、再生を続けるために、AVAudioSessionをAVAudioSessionCategoryPlaybackに
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *error;
        [session setCategory:AVAudioSessionCategoryPlayback error:&error];
        [session setActive:YES error:&error];

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)setCurrentString:(NSString *)currentString
{
    NSString *pastString = _currentString;
    if (![_currentString isEqualToString:currentString]) {
        _currentString = currentString;
    }

    [self updatePlayingSoundInfo];

    if ([self.delegate respondsToSelector:@selector(soundPlayerManeger:soundDidChanged:pastString:)]) {
        [self.delegate soundPlayerManeger:self soundDidChanged:_currentString pastString:pastString];
    }
}

- (BOOL)isPlaying
{
    return [_player isPlaying];
}

- (BOOL)isLooping
{
    return [_player numberOfLoops] == -1;
}

- (void)setLooping:(BOOL)looping
{
    [_player setNumberOfLoops:looping? -1: 0];
}

- (void)stop
{
    [self pause];
    _player = nil;

    if (_completionHandler) _completionHandler(NO);
    [[NSNotificationCenter defaultCenter] postNotificationName:MCTSoundPlayerManagerDidFinishPlayingNotification object:self];
}

- (void)play
{
    if (self.isPlaying == NO) {
        if (_player != nil) {
            [_player setDelegate:self];
            [_player play];
            _shouldResume = YES;
            if ([self.delegate respondsToSelector:@selector(soundPlayerManeger:soundDidStoped:)]) {
                [self.delegate soundPlayerManeger:self soundDidStoped:self.isPlaying];
            }
        } else {
            [self playWithString:self.currentString];
        }
    }
}

- (void)pause
{
    if (self.isPlaying == YES) {
        [_player pause];
        _shouldResume = NO;
        if ([self.delegate respondsToSelector:@selector(soundPlayerManeger:soundDidStarted:)]) {
            [self.delegate soundPlayerManeger:self soundDidStarted:self.isPlaying];
        }
    }
}

- (void)change
{
    if (self.isPlaying == YES) {
        [self stop];
    }

    if ([self.delegate respondsToSelector:@selector(soundPlayerManeger:soundShouldChange:)]) {
        [self.delegate soundPlayerManeger:self soundShouldChange:_currentString];
    }
}

- (void)next
{
    [self change];
}

- (void)prev
{
    [self change];
}

- (void)playOrPause
{
    if (self.isPlaying == YES) {
        [self pause];
    }
    else {
        [self play];
    }
}

- (void)playWithString:(NSString *)string
{
    if (self.isPlaying == YES) {
        [self stop];
    }

    self.currentString = string;
    NSData *soundData = [[MCTMorseSound sharedSound] soundDataWithString:string];
    _player = [[AVAudioPlayer alloc] initWithData:soundData error:NULL];
    [AVAudioSession sharedInstance];
    [_player prepareToPlay];
    [self play];
}

- (void)updatePlayingSoundInfo
{

}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(__unused AVAudioPlayer *)player successfully:(__unused BOOL)finishedPlaying
{
    [self stop];

    //fire events
    if (_completionHandler) _completionHandler(NO);
    [[NSNotificationCenter defaultCenter] postNotificationName:MCTSoundPlayerManagerDidFinishPlayingNotification object:self];
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
            if (_shouldResume) {
                [self play];
            }
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
                [self playOrPause];
                break;
            case UIEventSubtypeRemoteControlStop:
                [self stop];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self next];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self prev];
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
