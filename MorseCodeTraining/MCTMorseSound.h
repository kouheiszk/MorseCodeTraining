//
//  MCTMorseSound.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/18.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCTMorseSound : NSObject

@property (nonatomic, readonly) NSString *string;
@property (nonatomic, readonly) NSString *morseCodeString;
@property (nonatomic, readonly) NSData *soundData;

@property (nonatomic) NSInteger frequency;
@property (nonatomic) NSInteger wpm;

+ (MCTMorseSound *)sharedSound;
- (NSData *)soundDataWithString:(NSString *)string;

@end
