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

+ (MCTSound *)soundWithString:(NSString *)string;
- (MCTSound *)initWithString:(NSString *)string;
+ (MCTSound *)soundWithSoundData:(NSData *)soundData;
- (MCTSound *)initWithSoundData:(NSData *)soundData;

@property (nonatomic, readonly) NSData *soundData;
@property (nonatomic, readonly, getter = isPlaying) BOOL playing;
@property (nonatomic, getter = isLooping) BOOL looping;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval currentTime;
@property (nonatomic, copy) MCTSoundCompletionHandler completionHandler;

- (void)play;
- (void)pause;
- (void)stop;

@end


@interface MCTSoundManager : NSObject

@property (nonatomic, readonly, getter = isPlayingSound) BOOL playingSound;
@property (nonatomic) BOOL loopingSound;
@property (nonatomic) BOOL allowsBackgroundSound;

+ (MCTSoundManager *)sharedManager;

- (void)playSound:(id)soundOrString;
- (void)playOrPauseSound;
- (void)stopSound;

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent;

@end