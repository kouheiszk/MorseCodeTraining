//
//  MCTReceiveViewController.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/12.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTReceiveViewController.h"

#import "MCTMorseSound.h"
#import "MCTSoundPlayerManager.h"

@interface MCTReceiveViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loopButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back5sButton;

@end

@implementation MCTReceiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    MCTSoundPlayerManager *manager = [MCTSoundPlayerManager sharedManager];
    manager.delegate = self;

    if (!manager.isPlaying) {
        NSString *string = @"OSO OSO OSO CQ CQ DE JA2UIE";
        [manager playWithString:string];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updatePlayerConsole
{
    if ([MCTSoundPlayerManager sharedManager].isPlaying) {
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause"]];
    }
    else {
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"play"]];
    }
}

#pragma mark - IBActions

- (IBAction)playOrPauseButtonTapped:(id)sender
{
    [[MCTSoundPlayerManager sharedManager] playOrPause];
}

- (IBAction)backButtonTapped:(id)sender
{
    [[MCTSoundPlayerManager sharedManager] prev];
}

- (IBAction)nextButtonTapped:(id)sender
{
    [[MCTSoundPlayerManager sharedManager] next];
}

- (IBAction)loopButtonTapped:(id)sender
{
    BOOL shouldLooping = ![MCTSoundPlayerManager sharedManager].isLooping;
    [MCTSoundPlayerManager sharedManager].looping = shouldLooping;
    [self updatePlayerConsole];
}

#pragma mark - MCTSoundPlayerManagerDelegate

- (void)soundPlayerManeger:(MCTSoundPlayerManager *)soundPlayerManeger soundShouldChange:(NSString *)pastString
{
    [soundPlayerManeger playWithString:@"ABCD"];
    [self updatePlayerConsole];
}

- (void)soundPlayerManeger:(MCTSoundPlayerManager *)soundPlayerManeger soundDidChanged:(NSString *)string pastString:(NSString *)pastString
{
    [self updatePlayerConsole];
}

- (void)soundPlayerManeger:(MCTSoundPlayerManager *)soundPlayerManeger soundDidStarted:(BOOL)isPlayingSound
{
    [self updatePlayerConsole];
}

- (void)soundPlayerManeger:(MCTSoundPlayerManager *)soundPlayerManeger soundDidStoped:(BOOL)isPlayingSound
{
    [self updatePlayerConsole];
}


@end
