//
//  MCTReceiveViewController.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/12.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTReceiveViewController.h"

#import "NSString+MorseCode.h"
#import "MCTMorseCodePlayer.h"

@interface MCTReceiveViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *repeatButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back5sButton;

@property (nonatomic) MCTMorseCodePlayer *player;

@end

@implementation MCTReceiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _player = [[MCTMorseCodePlayer alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)playButtonTapped:(id)sender {
    [self.player reset];
    NSString *morseString = @"OSO OSO OSO CQ CQ DE JA2UIE";
    [self.player playMorse:[morseString morseStringWithString]];
}

- (IBAction)backButtonTapped:(id)sender {
}

- (IBAction)nextButtonTapped:(id)sender {
}

- (IBAction)repeatButtonTapped:(id)sender {
}

@end
