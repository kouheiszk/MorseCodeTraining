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

@property (nonatomic) MCTMorseCodeCharacterModel *character;
@property (nonatomic) MCTMorseCodeSettingModel *setting;

+ (MCTModel *)sharedModel;

@end
