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

@interface MCTPlayViewController ()

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *playOrPauseButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *loopButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *back5sButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;

@end

@implementation MCTPlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![MCTSoundManager sharedManager].playingSound) {
        NSString *string = [MCTModel sharedModel].strings;
        [[MCTSoundManager sharedManager] setWpm:[MCTModel sharedModel].wpm];
        [[MCTSoundManager sharedManager] setFrequency:[MCTModel sharedModel].frequency];
        [[MCTSoundManager sharedManager] playSound:string];
    }
//    [self updatePlayerConsole];
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

//- (void)updatePlayerConsole
//{
//    if ([MCTSoundManager sharedManager].playingSound) {
//        [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause"]];
//    }
//    else {
//        [self.playOrPauseButton setImage:[UIImage imageNamed:@"play"]];
//    }
//}

#pragma mark - IBActions

//- (IBAction)playOrPauseButtonTapped:(id)sender
//{
//    NSLog(@"play or pause button");
//    [[MCTSoundManager sharedManager] playOrPauseSound];
//    [self updatePlayerConsole];
//}
//
//- (IBAction)backButtonTapped:(id)sender
//{
//    NSLog(@"back button");
//    [self updatePlayerConsole];
//}
//
//- (IBAction)nextButtonTapped:(id)sender
//{
//    NSLog(@"next button");
//    [self updatePlayerConsole];
//}
//
//- (IBAction)loopButtonTapped:(id)sender
//{
//    NSLog(@"loop button");
//    [self updatePlayerConsole];
//}

@end
