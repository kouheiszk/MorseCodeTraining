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

@end
