//
//  MCTSoundManager.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/02/01.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

@protocol MCTSoundManagerDelegate;

@interface MCTSoundManager : NSObject

@property (nonatomic, readonly, getter = isPlayingSound) BOOL playingSound;
@property (nonatomic, readonly, getter = isSettedSound) BOOL settedSound;
@property (nonatomic) BOOL loopingSound;
@property (nonatomic) BOOL allowsBackgroundSound;

@property (nonatomic) id delegate;

+ (MCTSoundManager *)sharedManager;

- (void)preSetSound:(id)soundOrString;
- (void)playSound:(id)soundOrString;
- (void)playOrPauseSound;
- (void)playSound;
- (void)pauseSound;
- (void)stopSound;

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent;

- (void)setWpm:(NSInteger)wpm;
- (void)setFrequency:(NSInteger)frequency;

@end


@protocol MCTSoundManagerDelegate <NSObject>

- (void)soundDidFinishPlaying:(NSString *)soundString;

@end