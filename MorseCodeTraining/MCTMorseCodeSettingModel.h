//
//  MCTMorseCodeSettingModel.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/04/05.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MCTMorseCodeSettingType) {
    MCTMorseCodeSettingTypeNone,
    MCTMorseCodeSettingTypeWordLength,
    MCTMorseCodeSettingTypeWordCount,
    MCTMorseCodeSettingTypeWpm,
    MCTMorseCodeSettingTypeFrequency,
};

@interface MCTMorseCodeSettingModel : NSObject

- (NSString *)typeStringWithType:(MCTMorseCodeSettingType)type;
- (MCTMorseCodeSettingType)typeWithTypeString:(NSString *)typeString;

- (NSArray *)optionsWithType:(MCTMorseCodeSettingType)type;

- (NSDictionary *)settings;
- (NSInteger)settingedValueWithType:(MCTMorseCodeSettingType)type;
- (void)type:(MCTMorseCodeSettingType)type settingValue:(NSInteger)value;

@end
