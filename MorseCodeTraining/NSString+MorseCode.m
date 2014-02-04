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

+ (NSString *)morseCodeStringWithString:(NSString *)string
{
    NSLog(@"Incoming message: %@", string);
    NSMutableString *morseCodeStrings = [NSMutableString new];

    NSRange range;
    range.length = 1;
    range.location = 0;
    for (int i = 0; i < string.length; ++i) {
        range.location = i;
        NSString *character = [string substringWithRange:range];
        NSString *morseString = [NSString morseCodeForCharacter:character];
        if (i != 0 && ![character isEqualToString:@" "]) [morseCodeStrings appendString:@" "];
        [morseCodeStrings appendString:morseString];
    }

    return morseCodeStrings;
}

+ (NSArray *)morseCodeArrayWithString:(NSString *)string
{
    NSLog(@"Incoming message: %@", string);
    NSMutableArray *morseCodeArray = [NSMutableArray new];

    NSRange range;
    range.length = 1;
    range.location = 0;
    for (int i = 0; i < string.length; ++i) {
        range.location = i;
        NSString *character = [string substringWithRange:range];
        NSString *morseString = [NSString morseCodeForCharacter:character];
        [morseCodeArray addObject:morseString];
    }

    return morseCodeArray;
}

+ (NSString *)stringWithMorseCodeArray:(NSArray *)morseCodeArray
{
    NSMutableString *string = [NSMutableString new];
    for (NSString *code in morseCodeArray) {
        NSAssert([[[NSString codeMap] allKeysForObject:code] count], @"Code not found, did you make a typo?");
        NSString *character = [[NSString codeMap] allKeysForObject:code][0];
        [string appendString:character];
    }

    return string;
}

- (NSString *)morseCodeStringWithString
{
    return [[self class] morseCodeStringWithString:self];
}

- (NSArray *)morseCodeArrayWithString
{
    return [[self class] morseCodeArrayWithString:self];
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
