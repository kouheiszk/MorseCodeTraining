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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *repeatButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back5sButton;

@end

@implementation MCTReceiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updatePlayerConsole
{
    if ([MCTSoundPlayerManager sharedManager].playingSound) {
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause"]];
    }
    else {
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"play"]];
    }
}

#pragma mark - IBActions

- (IBAction)playOrPauseButtonTapped:(id)sender
{
    if (![MCTSoundPlayerManager sharedManager].playingSound) {
        NSString *string = @"OSO OSO OSO CQ CQ DE JA2UIE";
        NSData *soundData = [[MCTMorseSound sharedSound] soundDataWithString:string];
        [[MCTSoundPlayerManager sharedManager] playSound:soundData looping:YES];
        [_playOrPauseButton setImage:[UIImage imageNamed:@"pause"]];
        return;
    }

    if([MCTSoundPlayerManager sharedManager].pausingSound) {
        // 再生していない状態
        [[MCTSoundPlayerManager sharedManager] playSound];
        [_playOrPauseButton setImage:[UIImage imageNamed:@"pause"]];
    }
    else {
        // 再生している状態
        [[MCTSoundPlayerManager sharedManager] pauseSound];
        [_playOrPauseButton setImage:[UIImage imageNamed:@"play"]];
    }
}

- (IBAction)backButtonTapped:(id)sender {

}

- (IBAction)nextButtonTapped:(id)sender {

}

- (IBAction)repeatButtonTapped:(id)sender {

}

#pragma mark - MCTSoundPlayerManagerDelegate

- (void)soundPlayerManeger:(MCTSoundPlayerManager *)soundPlayerManeger soundDidChanged:(NSData *)soundData past:(NSInteger)past
{
    [self updatePlayerConsole];
}

- (void)soundPlayerManeger:(MCTSoundPlayerManager *)soundPlayerManeger soundDidStarted:(NSData *)soundData
{
    [self updatePlayerConsole];
}

- (void)soundPlayerManeger:(MCTSoundPlayerManager *)soundPlayerManeger soundDidStoped:(NSData *)soundData
{
    [self updatePlayerConsole];
}

@end
