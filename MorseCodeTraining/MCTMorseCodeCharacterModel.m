//
//  MCTMorseCodeModel.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/03/29.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTMorseCodeCharacterModel.h"

#import "NSUserDefaults+MCTAdditions.h"

@interface MCTMorseCodeCharacterModel ()

@property (nonatomic) NSDictionary *characterTypeMap;
@property (nonatomic) NSDictionary *morseCodeCharacters;

@end

@implementation MCTMorseCodeCharacterModel

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initSharedInstance
{
    if (self = [super init]) {
        _characterTypeMap = @{@(MCTMorseCodeCharacterTypeAlphabet) : @"alphabet",
                              @(MCTMorseCodeCharacterTypeNumber)   : @"number",
                              @(MCTMorseCodeCharacterTypeSymbol)   : @"symbol"};

        _morseCodeCharacters = [self morseCodeCharactersFromPlist];
    }
    return self;
}

+ (MCTMorseCodeCharacterModel *)sharedModel
{
    static MCTMorseCodeCharacterModel *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MCTMorseCodeCharacterModel alloc] initSharedInstance];
    });
    return sharedInstance;
}

#pragma mark - Getter

- (NSArray *)enableCharacters
{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    return (d.storedEnableCharacters != nil) ? d.storedEnableCharacters : [NSArray array];
}

#pragma mark - Public methods

- (NSString *)typeStringWithType:(MCTMorseCodeCharacterType)type
{
    return self.characterTypeMap[@(type)];
}

- (MCTMorseCodeCharacterType)typeWithTypeString:(NSString *)typeString
{
    for (NSNumber *typeNumber in self.characterTypeMap) {
        if ([self.characterTypeMap[typeNumber] isEqualToString:typeString]) {
            return [typeNumber integerValue];
        }
    }

    return MCTMorseCodeCharacterTypeAll;
}

- (NSDictionary *)morseCodeTableWithType:(MCTMorseCodeCharacterType)type
{
    NSString *typeString = [self typeStringWithType:type];

    if (typeString) return self.morseCodeCharacters[typeString];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *typeDicKey in self.morseCodeCharacters) {
        [dic addEntriesFromDictionary:self.morseCodeCharacters[typeDicKey]];
    }

    return dic;
}

- (NSArray *)charactersWithType:(MCTMorseCodeCharacterType)type
{
    NSDictionary *morseCodeTable = [self morseCodeTableWithType:type];
    NSArray *characters = morseCodeTable.allKeys;

    return [characters sortedArrayUsingComparator:^(NSString *obj1, NSString *obj2) {
        return [obj1 localizedCaseInsensitiveCompare:obj2];
    }];
}

- (BOOL)isEnableCharacter:(NSString *)character
{
    NSArray *storedEnableCharacters = [self enableCharacters];
    return [storedEnableCharacters containsObject:character];
}

- (void)character:(NSString *)character enable:(BOOL)enable
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

- (NSDictionary *)morseCodeCharactersFromPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MCTMorseCode" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return dictionary[@"characters"];
}

@end
