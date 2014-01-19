//
//  MCTViewController.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/12.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTViewController.h"

#import "NSString+MorseCode.h"
#import "MCTMorseCodePlayer.h"

@interface MCTViewController ()
@property (nonatomic) MCTMorseCodePlayer *player;
@end

@implementation MCTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _player = [MCTMorseCodePlayer new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(id)sender {
    [self.player reset];
    NSString *morseString = @"OSO OSO OSO CQ CQ DE JA2UIE";
    [self.player playMorse:[morseString morseStringWithString]];
}

@end
