//
//  NSString+MorseCode.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/13.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MorseCode)

+ (NSString *)morseStringWithString:(NSString *)morseString;
+ (NSArray *)morseArrayWithString:(NSString *)morseString;
+ (NSString *)stringWithMorseArray:(NSArray *)morseArray;

- (NSString *)morseStringWithString;
- (NSArray *)morseArrayWithString;

@end
