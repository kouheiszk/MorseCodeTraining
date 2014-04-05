//
//  MCTPickSettingViewController.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/04/03.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCTSettingViewControllerProtocol.h"

@interface MCTPickSettingViewController : UITableViewController <MCTSettingViewControllerProtocol>
@property (nonatomic) NSString *settingTarget;
@end
