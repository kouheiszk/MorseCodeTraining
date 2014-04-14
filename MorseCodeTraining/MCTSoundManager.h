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

@interface MCTSoundManager : NSObject

@property (nonatomic, readonly, getter = isPlayingSound) BOOL playingSound;
@property (nonatomic) BOOL loopingSound;
@property (nonatomic) BOOL allowsBackgroundSound;

+ (MCTSoundManager *)sharedManager;

- (void)playSound:(id)soundOrString;
- (void)playOrPauseSound;
- (void)playSound;
- (void)pauseSound;
- (void)stopSound;

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent;

- (void)setWpm:(NSInteger)wpm;
- (void)setFrequency:(NSInteger)frequency;

@end