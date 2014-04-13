//
//  MCTModel.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/04/13.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTModel.h"

@implementation MCTModel

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initSharedInstance
{
    if (self = [super init]) {
        _character = [[MCTMorseCodeCharacterModel alloc] init];
        _setting = [[MCTMorseCodeSettingModel alloc] init];
    }
    return self;
}

+ (MCTModel *)sharedModel
{
    static MCTModel *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MCTModel alloc] initSharedInstance];
    });
    return sharedInstance;
}

#pragma mark - Getter

- (NSString *)strings
{
    int count = [self.setting settingedValueWithType:MCTMorseCodeSettingTypeWordCount];
    NSInteger length = [self.setting settingedValueWithType:MCTMorseCodeSettingTypeWordLength];

    NSMutableString *strings = [NSMutableString string];

    for (int i = 0; i < count; i++) {
        if (i != 0) [strings appendString:@" "];
        for (int j = 0; j < length; j++) {
            [strings appendString:[self randomCharacter]];
        }
    }

    return [strings copy];
}

- (NSInteger)wpm
{
    return [self.setting settingedValueWithType:MCTMorseCodeSettingTypeWpm];
}

- (NSInteger)frequency
{
    return [self.setting settingedValueWithType:MCTMorseCodeSettingTypeFrequency];
}

#pragma mark - Private methods

- (NSString *)randomCharacter
{
    return self.character.enableCharacters[(arc4random() % self.character.enableCharacters.count)];
}

@end
