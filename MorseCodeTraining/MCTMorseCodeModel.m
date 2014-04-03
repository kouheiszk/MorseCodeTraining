//
//  MCTMorseCodeModel.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/03/29.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTMorseCodeModel.h"

#import "NSUserDefaults+MCTAdditions.h"

@implementation MCTMorseCodeModel

#pragma mark - Public methods

+ (NSDictionary *)morseCodeMapWithType:(MCTMorseCodeCharacterType)type
{
    NSDictionary *morseCodeMaps = [self morseCodeMapFromPlist];
    NSString *typeString = [self typeStringWithType:type];

    if (typeString) return morseCodeMaps[typeString];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSDictionary *typeDic in morseCodeMaps) {
        [dic addEntriesFromDictionary:typeDic];
    }

    return dic;
}

+ (NSArray *)charactersWithType:(MCTMorseCodeCharacterType)type
{
    NSDictionary *morseCodeMap = [self morseCodeMapWithType:type];
    NSArray *characters = morseCodeMap.allKeys;

    return [characters sortedArrayUsingComparator:^(NSString *obj1, NSString *obj2) {
        return [obj1 localizedCaseInsensitiveCompare:obj2];
    }];
}

+ (NSString *)typeStringWithType:(MCTMorseCodeCharacterType)type
{
    switch (type) {
        case MCTMorseCodeCharacterTypeAll:
            return nil;
        case MCTMorseCodeCharacterTypeAlphabet:
            return @"alphabet";
        case MCTMorseCodeCharacterTypeNumber:
            return @"number";
        case MCTMorseCodeCharacterTypeSymbol:
            return @"symbol";
    }
}

+ (MCTMorseCodeCharacterType)typeWithTypeString:(NSString *)typeString
{
    if ([typeString isEqualToString:@"alphabet"]) return MCTMorseCodeCharacterTypeAlphabet;
    if ([typeString isEqualToString:@"number"]) return MCTMorseCodeCharacterTypeNumber;
    if ([typeString isEqualToString:@"symbol"]) return MCTMorseCodeCharacterTypeSymbol;
    return MCTMorseCodeCharacterTypeAll;
}

+ (NSArray *)enableCharacters
{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    return (d.storedEnableCharacters != nil) ? d.storedEnableCharacters : [NSArray array];
}

+ (BOOL)isEnableCharacter:(NSString *)character
{
    NSArray *storedEnableCharacters = [self enableCharacters];
    return [storedEnableCharacters containsObject:character];
}

+ (void)character:(NSString *)character enable:(BOOL)enable
{
    // 登録状態と指定が同じであれば何もしない
    if ([self isEnableCharacter:character] == enable) return;

    NSMutableArray *enableCharacters = [self enableCharacters].mutableCopy;
    if (enable) {
        [enableCharacters addObject:character];
    } else {
        [enableCharacters removeObject:character];
    }

    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    d.storedEnableCharacters = [enableCharacters copy];
}

#pragma mark - Private methods

+ (NSDictionary *)morseCodeMapFromPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MCTMorseCode" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return dictionary;
}

+ (NSComparisonResult)compareCaracter:(NSString *)string
{
    return [string localizedCaseInsensitiveCompare:string];
}

@end
