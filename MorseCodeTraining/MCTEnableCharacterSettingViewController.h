//
//  MCTEnableCharacterSettingViewController.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/02/09.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCTSettingViewControllerProtocol.h"

@interface MCTEnableCharacterSettingViewController : UITableViewController <MCTSettingViewControllerProtocol>
@property (nonatomic) NSString *settingTarget;
@end
