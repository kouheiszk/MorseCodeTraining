//
//  MCTMorseCodeModel.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/03/29.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTMorseCodeModel.h"

static NSString *const kTypeAlphabet = @"alphabet";
static NSString *const kTypeNumber = @"number";
static NSString *const kTypeSymbol = @"symbol";

@implementation MCTMorseCodeModel

#pragma mark - Public methods

+ (NSDictionary *)getAllCodeMap
{
    NSDictionary *morseCodeMap = [self morseCodeMapFromPlist];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSDictionary *typeDic in morseCodeMap) {
        [dic addEntriesFromDictionary:typeDic];
    }

    return dic;
}

+ (NSDictionary *)getAlphabelCodeMap
{
    NSDictionary *morseCodeMap = [self morseCodeMapFromPlist];
    return morseCodeMap[kTypeAlphabet];
}

+ (NSDictionary *)getNumberCodeMap
{
    NSDictionary *morseCodeMap = [self morseCodeMapFromPlist];
    return morseCodeMap[kTypeNumber];
}

+ (NSDictionary *)getSymbolCodeMap
{
    NSDictionary *morseCodeMap = [self morseCodeMapFromPlist];
    return morseCodeMap[kTypeSymbol];
}

#pragma mark - Private methods

+ (NSDictionary *)morseCodeMapFromPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MCTMorseCode" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return dictionary;
}

@end
