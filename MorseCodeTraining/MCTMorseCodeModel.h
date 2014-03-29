//
//  MCTMorseCodeModel.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/03/29.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCTMorseCodeModel : NSObject

+ (NSDictionary *)getAllCodeMap;
+ (NSDictionary *)getAlphabelCodeMap;
+ (NSDictionary *)getNumberCodeMap;
+ (NSDictionary *)getSymbolCodeMap;

@end
