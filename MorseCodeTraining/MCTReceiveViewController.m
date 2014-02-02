//
//  MCTReceiveViewController.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/12.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTReceiveViewController.h"

#import "NSString+MorseCode.h"
#import "MCTMorseSoundGenerator.h"
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
    [MCTSoundPlayerManager sharedManager].allowsBackgroundSound = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)playOrPauseButtonTapped:(id)sender
{

    if (![MCTSoundPlayerManager sharedManager].playingSound) {
        NSString *morseString = @"OSO OSO OSO CQ CQ DE JA2UIE";
        NSData *morseSoundData = [MCTMorseSoundGenerator generateMorseSoundData:[morseString morseStringWithString]];
        [[MCTSoundPlayerManager sharedManager] playSound:morseSoundData looping:YES fadeIn:NO];
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

@end
