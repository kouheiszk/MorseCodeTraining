//
//  NSUserDefaults+MCTAdditions.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/04/02.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "NSUserDefaults+MCTAdditions.h"

static NSString *const kStoredEnableCharactersKey = @"enableCharacters";
static NSString *const kStoredSettingsKey = @"storedSettings";

@implementation NSUserDefaults (MCTAdditions)

- (NSArray *)storedEnableCharacters
{
    return [self arrayForKey:kStoredEnableCharactersKey];
}

- (void)setStoredEnableCharacters:(NSArray *)enableCharacters
{
    [self setObject:enableCharacters forKey:kStoredEnableCharactersKey];
    [self synchronize];
}

- (NSDictionary *)storedSettings
{
    return [self dictionaryForKey:kStoredSettingsKey];
}

- (void)setStoredSettings:(NSDictionary *)settings
{
    [self setObject:settings forKey:kStoredSettingsKey];
    [self synchronize];
}

@end
