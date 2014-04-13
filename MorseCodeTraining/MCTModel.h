//
//  MCTModel.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/04/13.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MCTMorseCodeCharacterModel.h"
#import "MCTMorseCodeSettingModel.h"

@interface MCTModel : NSObject

@property (nonatomic, readonly) MCTMorseCodeCharacterModel *character;
@property (nonatomic, readonly) MCTMorseCodeSettingModel *setting;

@property (nonatomic, readonly) NSString *strings;
@property (nonatomic, readonly) NSInteger wpm;
@property (nonatomic, readonly) NSInteger frequency;

+ (MCTModel *)sharedModel;

@end
