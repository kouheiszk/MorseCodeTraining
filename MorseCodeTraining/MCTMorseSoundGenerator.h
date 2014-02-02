//
//  MCTMorseSoundGenerator.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/18.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCTMorseSoundGenerator : NSObject

+ (NSData *)generateMorseSoundData:(NSString *)morseString;

@end
