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

#import "MCTMorseCodeCharacterModel.h"

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
        NSAssert([[[MCTMorseCodeCharacterModel morseCodeMapWithType:MCTMorseCodeCharacterTypeAll] allKeysForObject:code] count], @"Code not found, did you make a typo?");
        NSString *character = [[MCTMorseCodeCharacterModel morseCodeMapWithType:MCTMorseCodeCharacterTypeAll] allKeysForObject:code][0];
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
    NSString *codeString = [MCTMorseCodeCharacterModel morseCodeMapWithType:MCTMorseCodeCharacterTypeAll][keyString];
    if (!codeString) codeString = @"";

    NSLog(@"Converting %@ to %@", keyString, codeString);

    return codeString;
}

+ (NSString *)characterForMorseCode:(NSString *)code
{
    NSAssert(code.length > 0 && code.length <= 6, @"Length of code must be between 1-6 characters");
    NSAssert([[[MCTMorseCodeCharacterModel morseCodeMapWithType:MCTMorseCodeCharacterTypeAll] allKeysForObject:code] count], @"Code not found, did you make a typo?");

    return [[MCTMorseCodeCharacterModel morseCodeMapWithType:MCTMorseCodeCharacterTypeAll] allKeysForObject:code][0];
}

@end
