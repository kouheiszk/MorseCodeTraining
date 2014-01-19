//
//  MCTMorseCodePlayer.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/18.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCTMorseCodePlayer : NSObject
- (void)playMorse:(NSString *)morseString;
- (void)reset;
@end
