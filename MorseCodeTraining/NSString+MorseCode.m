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

+ (NSString *)morseStringWithString:(NSString *)morseString
{
    NSLog(@"Incoming message: %@", morseString);
    NSMutableString *morseStrings = [NSMutableString new];

    NSRange range;
    range.length = 1;
    range.location = 0;
    for (int i = 0; i < morseString.length; ++i) {
        range.location = i;
        NSString *character = [morseString substringWithRange:range];
        NSString *morseString = [NSString morseCodeForCharacter:character];
        if (i != 0 && ![character isEqualToString:@" "]) [morseStrings appendString:@" "];
        [morseStrings appendString:morseString];
    }

    return morseStrings;
}

+ (NSArray *)morseArrayWithString:(NSString *)morseString
{
    NSLog(@"Incoming message: %@", morseString);
    NSMutableArray *morseArray = [NSMutableArray new];

    NSRange range;
    range.length = 1;
    range.location = 0;
    for (int i = 0; i < morseString.length; ++i) {
        range.location = i;
        NSString *character = [morseString substringWithRange:range];
        NSString *morseString = [NSString morseCodeForCharacter:character];
        [morseArray addObject:morseString];
    }

    return morseArray;
}

+ (NSString *)stringWithMorseArray:(NSArray *)morseArray
{
    NSMutableString *string = [NSMutableString new];
    for (NSString *code in morseArray) {
        NSAssert([[[NSString codeMap] allKeysForObject:code] count], @"Code not found, did you make a typo?");
        NSString *character = [[NSString codeMap] allKeysForObject:code][0];
        [string appendString:character];
    }

    return string;
}

- (NSString *)morseStringWithString
{
    return [[self class] morseStringWithString:self];
}

- (NSArray *)morseArrayWithString
{
    return [[self class] morseArrayWithString:self];
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
             @" ": @"  ",
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
