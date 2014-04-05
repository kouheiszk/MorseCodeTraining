//
//  MCTMorseCodeSettingModel.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/04/05.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTMorseCodeSettingModel.h"

#import "NSUserDefaults+MCTAdditions.h"

static const NSInteger kDefaultStride = 1;

@implementation MCTMorseCodeSettingModel

#pragma mark - Public methods

+ (NSString *)typeStringWithType:(MCTMorseCodeSettingType)type
{
    switch (type) {
        case MCTMorseCodeSettingTypeWordLength:
            return @"word_length";
        case MCTMorseCodeSettingTypeWordCount:
            return @"word_count";
        case MCTMorseCodeSettingTypeWpm:
            return @"wpm";
        case MCTMorseCodeSettingTypeFrequency:
            return @"frequency";
        case MCTMorseCodeSettingTypeNone:
            return nil;
    }
}

+ (MCTMorseCodeSettingType)typeWithTypeString:(NSString *)typeString
{
    if ([typeString isEqualToString:@"word_length"]) return MCTMorseCodeSettingTypeWordLength;
    if ([typeString isEqualToString:@"word_count"]) return MCTMorseCodeSettingTypeWordCount;
    if ([typeString isEqualToString:@"wpm"]) return MCTMorseCodeSettingTypeWpm;
    if ([typeString isEqualToString:@"frequency"]) return MCTMorseCodeSettingTypeFrequency;
    return MCTMorseCodeSettingTypeNone;
}

+ (NSArray *)optionsWithType:(MCTMorseCodeSettingType)type
{
    NSDictionary *setting = [self settingWithType:type];
    NSUInteger min = [setting[@"min"] unsignedIntegerValue];
    NSUInteger max = [setting[@"max"] unsignedIntegerValue];
    NSUInteger stride = [setting[@"stride"] unsignedIntegerValue];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = min; i <= max; i += stride) {
        [array addObject:@(i)];
    }
    return [array copy];
}

+ (NSDictionary *)settings
{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    return (d.storedSettings != nil) ? d.storedSettings : [NSDictionary dictionary];
}

+ (NSInteger)settingedValueWithType:(MCTMorseCodeSettingType)type
{
    NSDictionary *settings = [self settings];
    NSString *typeString = [self typeStringWithType:type];

    if (!settings[typeString]) {
        // 値がUserDefaultsに保存されていなかったらplistのdefault値を利用する
        NSDictionary *setting = [self settingWithType:type];
        return [setting[@"default"] integerValue];
    }

    return [settings[typeString] integerValue];
}

+ (void)type:(MCTMorseCodeSettingType)type settingValue:(NSInteger)value
{
    // 登録状態と指定が同じであれば何もしない
    if ([self settingedValueWithType:type] == value) return;

    NSMutableDictionary *settings = [self settings].mutableCopy;
    NSString *typeString = [self typeStringWithType:type];
    settings[typeString] = @(value);

    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    d.storedSettings = [settings copy];
}

#pragma mark - Private methods

+ (NSDictionary *)morseCodeSettingsFromPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MCTMorseCode" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return dictionary[@"settings"];
}

+ (NSDictionary *)settingWithType:(MCTMorseCodeSettingType)type
{
    NSDictionary *settings = [self morseCodeSettingsFromPlist];
    NSMutableDictionary *setting = [settings[[self typeStringWithType:type]] mutableCopy];
    setting[@"stride"] = setting[@"stride"] ? setting[@"stride"] : @(kDefaultStride);
    return setting;
}

@end