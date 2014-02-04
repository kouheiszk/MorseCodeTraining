//
//  MCTSoundManager.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/02/01.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

extern NSString *const MCTSoundDidFinishPlayingNotification;

typedef void (^MCTSoundCompletionHandler)(BOOL didFinish);

@interface MCTSound : NSObject

+ (MCTSound *)soundWithSoundData:(NSData *)soundData;
- (MCTSound *)initWithSoundData:(NSData *)soundData;

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, strong) NSData *soundData;
@property (nonatomic, readonly, getter = isPlaying) BOOL playing;
@property (nonatomic, assign, getter = isLooping) BOOL looping;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, copy) MCTSoundCompletionHandler completionHandler;
@property (nonatomic, assign) float baseVolume;
@property (nonatomic, assign) float volume;
@property (nonatomic, assign) float pan;

- (void)play;
- (void)pause;
- (void)stop;

@end


#pragma mark - MCTSoundPlayerManager

@interface MCTSoundPlayerManager : NSObject <AVAudioSessionDelegate>

@property (nonatomic, readonly, getter = isPlayingSound) BOOL playingSound;
@property (nonatomic, readonly, getter = isPausingSound) BOOL pausingSound;
@property (nonatomic, assign) float soundVolume;
@property (nonatomic, assign) NSTimeInterval soundFadeDuration;
@property (nonatomic, weak) id delegate;

+ (MCTSoundPlayerManager *)sharedManager;

- (void)prepareToPlayWithSound:(id)soundOrSoundData;

- (void)playSound:(id)soundOrSoundData looping:(BOOL)looping;
- (void)playSound:(id)soundOrSoundData;

- (void)playSound;
- (void)pauseSound;
- (void)playOrPauseSound;
- (void)nextSound;
- (void)prevSound;
- (void)stopSound;

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent;

@end


#pragma mark - FNMusicPlayManagerDelegate

@protocol MCTSoundPlayerManagerDelegate <NSObject>

- (void)soundPlayerManeger:(MCTSoundPlayerManager *)soundPlayerManeger soundDidChanged:(NSData *)soundData past:(NSInteger)past;
- (void)soundPlayerManeger:(MCTSoundPlayerManager *)soundPlayerManeger soundDidStarted:(NSData *)soundData;
- (void)soundPlayerManeger:(MCTSoundPlayerManager *)soundPlayerManeger soundDidStoped:(NSData *)soundData;

@end