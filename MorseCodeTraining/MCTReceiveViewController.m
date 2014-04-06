//
//  MCTReceiveViewController.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/12.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTReceiveViewController.h"

#import "MCTMorseSound.h"
#import "MCTSoundManager.h"

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

    if (![MCTSoundManager sharedManager].playingSound) {
        NSString *string = @"OSO OSO OSO CQ CQ DE JA2UIE";
        [[MCTSoundManager sharedManager] playSound:string];
    }
    [self updatePlayerConsole];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updatePlayerConsole
{
    if ([MCTSoundManager sharedManager].playingSound) {
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause"]];
    }
    else {
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"play"]];
    }
}

#pragma mark - IBActions

- (IBAction)playOrPauseButtonTapped:(id)sender
{
    NSLog(@"play or pause button");
    [[MCTSoundManager sharedManager] playOrPauseSound];
    [self updatePlayerConsole];
}

- (IBAction)backButtonTapped:(id)sender
{
    NSLog(@"back button");
    [self updatePlayerConsole];
}

- (IBAction)nextButtonTapped:(id)sender
{
    NSLog(@"next button");
    [self updatePlayerConsole];
}

- (IBAction)loopButtonTapped:(id)sender
{
    NSLog(@"loop button");
    [self updatePlayerConsole];
}

@end
