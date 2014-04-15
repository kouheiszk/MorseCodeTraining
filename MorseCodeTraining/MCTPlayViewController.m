//
//  MCTReceiveViewController.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/12.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTPlayViewController.h"

#import "MCTMorseSound.h"
#import "MCTSoundManager.h"
#import "MCTModel.h"
#import "MCTSettingViewController.h"

@interface MCTPlayViewController () <MCTSoundManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;

@end

@implementation MCTPlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MCTSoundManager sharedManager].delegate = self;
    [self updatePlayerConsole];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    // 再生中であれば再生する
    [[MCTSoundManager sharedManager] playSound];

    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    // 画面遷移時は再生を中断する
    [[MCTSoundManager sharedManager] pauseSound];

    [super viewWillDisappear:animated];
}

#pragma mark - IBActions

- (IBAction)playOrPauseButtonTapped:(id)sender
{
    NSLog(@"play or pause button");

    if (![MCTSoundManager sharedManager].settedSound) {
        NSString *string = [MCTModel sharedModel].strings;
        [[MCTSoundManager sharedManager] setWpm:[MCTModel sharedModel].wpm];
        [[MCTSoundManager sharedManager] setFrequency:[MCTModel sharedModel].frequency];
        [[MCTSoundManager sharedManager] preSetSound:string];
    }

    [[MCTSoundManager sharedManager] playOrPauseSound];
    [self updatePlayerConsole];
}

#pragma mark - Private methods

- (void)updatePlayerConsole
{
    if ([MCTSoundManager sharedManager].playingSound) {
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause_fill"] forState:UIControlStateHighlighted];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause_fill"] forState:UIControlStateSelected];
    }
    else {
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"play_fill"] forState:UIControlStateHighlighted];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"play_fill"] forState:UIControlStateSelected];
    }
}

#pragma mark - MCTSoundManagerDelegate

- (void)soundDidFinishPlaying:(NSString *)soundString
{
    NSLog(@"\"%@\" was played.", soundString);
    [self updatePlayerConsole];
}

@end
