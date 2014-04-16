//
//  NSString+MorseCode.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/13.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MorseCode)

+ (NSString *)morseCodeStringWithString:(NSString *)string;
+ (NSArray *)morseCodeArrayWithString:(NSString *)string;
+ (NSString *)stringWithMorseCode:(NSString *)morseCode;
+ (NSString *)stringWithMorseCodeArray:(NSArray *)morseCodeArray;

- (NSString *)morseCodeStringWithString;
- (NSArray *)morseCodeArrayWithString;

@end
