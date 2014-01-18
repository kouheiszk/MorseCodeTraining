//
//  NSString+MorseCode.m
//  MorseCodeTraining
//
//  参考:
//  https://github.com/johnnyclem/Morse-Touch
//
//  Created by Suzuki Kouhei on 2014/01/13.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "NSString+MorseCode.h"

@implementation NSString (MorseCode)

#pragma mark - public

+ (NSString *)stringFromMorseCodeArray:(NSArray *)morseArray
{
    NSMutableString *morseString = [NSMutableString new];
    for (NSString *code in morseArray) {
        NSAssert([[[NSString codeMap] allKeysForObject:code] count], @"Code not found, did you make a typo?");
        NSString *character = [[NSString codeMap] allKeysForObject:code][0];
        [morseString appendString:character];
    }

    return morseString;
}

+ (NSArray *)morseArrayFromString:(NSString *)morseString
{
    NSLog(@"Incoming message: %@", morseString);
    NSMutableArray *morseArray = [NSMutableArray new];

    for (int i = 0; i < morseString.length; i++) {
        NSString *character = [NSString stringWithFormat:@"%c", [morseString characterAtIndex:i]];
        NSString *morseString = [NSString morseCodeForCharacter:character];
        NSLog(@"Converting Character %@ to Code %@", character, morseString);
        [morseArray addObject:morseString];
    }

    return morseArray;
}

#pragma mark - private

+ (NSString *)morseCodeForCharacter:(NSString *)character
{
    NSString *keyString = [character uppercaseString];
    NSString *codeString = [NSString codeMap][keyString];
    NSLog(@"Converting %@ to %@", keyString, codeString);

    return codeString;
}

+ (NSString *)characterForMorseCode:(NSString *)code
{
    NSAssert(code.length > 0 && code.length <= 6, @"Length of code must be between 1-6 characters");
    NSAssert([[[NSString codeMap] allKeysForObject:code] count], @"Code not found, did you make a typo?");

    return [[NSString codeMap] allKeysForObject:code][0];
}

+ (NSDictionary *)codeMap
{
    return @{
             @" ": @" ",
             @"A": @".-",
             @"B": @"-...",
             @"C": @"-.-.",
             @"D": @"-..",
             @"E": @".",
             @"F": @"..-.",
             @"G": @"--.",
             @"H": @"....",
             @"I": @"..",
             @"J": @".---",
             @"K": @"-.-",
             @"L": @".-..",
             @"M": @"--",
             @"N": @"-.",
             @"O": @"---",
             @"P": @".--.",
             @"Q": @"--.-",
             @"R": @".-.",
             @"S": @"...",
             @"T": @"-",
             @"U": @"..-",
             @"V": @"...-",
             @"W": @".--",
             @"X": @"-..-",
             @"Y": @"-.--",
             @"Z": @"--..",
             @"1": @".----",
             @"2": @"..---",
             @"3": @"...--",
             @"4": @"....-",
             @"5": @".....",
             @"6": @"-....",
             @"7": @"--...",
             @"8": @"---..",
             @"9": @"----.",
             @"0": @"-----",
             @".": @".-.-.-",
             @",": @"--..--",
             @":": @"---...",
             @";": @"-.-.-.",
             @"?": @"..--..",
             @"'": @".----.",
             @"-": @"-....-",
             @"/": @"-..-.",
             @"(": @"-.--.-",
             @")": @"-.--.-",
             @"\"": @".-..-.",
             @"@": @".--.-.",
             @"=": @"-...-",
             @"!": @"---.",
             @"[": @"-.--.",
             @"]": @"-.--.",
             @"+": @".-.-.",
             };
}

@end
