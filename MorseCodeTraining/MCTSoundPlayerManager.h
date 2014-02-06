//
//  MCTSoundManager.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/02/01.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

extern NSString *const MCTSoundPlayerManagerDidFinishPlayingNotification;

typedef void (^MCTSoundCompletionHandler)(BOOL didFinish);

#pragma mark - MCTSoundPlayerManager

@interface MCTSoundPlayerManager : NSObject <AVAudioSessionDelegate, AVAudioPlayerDelegate>

@property (nonatomic, readonly, getter = isPlaying) BOOL playing;
@property (nonatomic, getter = isLooping) BOOL looping;
@property (nonatomic) NSArray *palyStrings;
@property (nonatomic) NSArray *playList;
@property (nonatomic) NSString *currentString;
@property (nonatomic, copy) MCTSoundCompletionHandler completionHandler;
@property (nonatomic, weak) id delegate;

+ (MCTSoundPlayerManager *)sharedManager;

- (void)play;
- (void)pause;
- (void)next;
- (void)prev;
- (void)playOrPause;
- (void)playWithString:(NSString *)string;
- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent;

@end


#pragma mark - FNMusicPlayManagerDelegate

@protocol MCTSoundPlayerManagerDelegate <NSObject>

// TODO remove this
- (void)soundPlayerManeger:(MCTSoundPlayerManager *)soundPlayerManeger soundShouldChange:(NSString *)pastString;

- (void)soundPlayerManeger:(MCTSoundPlayerManager *)soundPlayerManeger soundDidChanged:(NSString *)string pastString:(NSString *)pastString;
- (void)soundPlayerManeger:(MCTSoundPlayerManager *)soundPlayerManeger soundDidStarted:(BOOL)isPlayingSound;
- (void)soundPlayerManeger:(MCTSoundPlayerManager *)soundPlayerManeger soundDidStoped:(BOOL)isPlayingSound;

@end