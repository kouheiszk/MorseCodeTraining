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

- (void)fadeTo:(float)volume duration:(NSTimeInterval)duration;
- (void)fadeIn:(NSTimeInterval)duration;
- (void)fadeOut:(NSTimeInterval)duration;
- (void)play;
- (void)stop;

@end


@interface MCTSoundPlayerManager : NSObject

@property (nonatomic, readonly, getter = isPlayingSound) BOOL playingSound;
@property (nonatomic, assign) BOOL allowsBackgroundSound;
@property (nonatomic, assign) float soundVolume;
@property (nonatomic, assign) NSTimeInterval soundFadeDuration;

+ (MCTSoundPlayerManager *)sharedManager;

- (void)prepareToPlayWithSound:(id)soundOrSoundData;

- (void)playSound:(id)soundOrSoundData looping:(BOOL)looping fadeIn:(BOOL)fadeIn;
- (void)playSound:(id)soundOrSoundData looping:(BOOL)looping;
- (void)playSound:(id)soundOrSoundData;

- (void)stopSound:(BOOL)fadeOut;
- (void)stopSound;

@end
