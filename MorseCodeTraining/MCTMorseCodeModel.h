//
//  MCTMorseCodeModel.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/03/29.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MCTMorseCodeCharacterType) {
    MCTMorseCodeCharacterTypeAll,
    MCTMorseCodeCharacterTypeAlphabet,
    MCTMorseCodeCharacterTypeNumber,
    MCTMorseCodeCharacterTypeSymbol,
};

@interface MCTMorseCodeModel : NSObject

+ (NSDictionary *)morseCodeMapWithType:(MCTMorseCodeCharacterType)type;
+ (NSArray *)charactersWithType:(MCTMorseCodeCharacterType)type;

+ (NSString *)typeStringWithType:(MCTMorseCodeCharacterType)type;
+ (MCTMorseCodeCharacterType)typeWithTypeString:(NSString *)typeString;

+ (NSArray *)enableCharacters;
+ (BOOL)isEnableCharacter:(NSString *)character;
+ (void)character:(NSString *)character enable:(BOOL)enable;

@end
