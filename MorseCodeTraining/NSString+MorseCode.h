//
//  NSString+MorseCode.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/13.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MorseCode)

+ (NSString *)stringFromMorseCodeArray:(NSArray *)morseArray;
+ (NSArray *)morseArrayFromString:(NSString *)morseString;

@end
