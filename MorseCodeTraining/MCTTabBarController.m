//
//  MCTTabBarController.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/29.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTTabBarController.h"

static NSString *const kReceiveStoryboardName = @"Receive";
static NSString *const kSettingStoryboardName = @"Setting";

@interface MCTTabBarController ()

@end

@implementation MCTTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.viewControllers = @[[[UIStoryboard storyboardWithName:kReceiveStoryboardName bundle:nil] instantiateInitialViewController],
                             [[UIStoryboard storyboardWithName:kSettingStoryboardName bundle:nil] instantiateInitialViewController]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
