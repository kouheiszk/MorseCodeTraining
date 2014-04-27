//
//  MCTReceiveViewController.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/12.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTPlayViewController.h"

#import <FXBlurView.h>
#import "NSString+MorseCode.h"
#import "MCTMorseSound.h"
#import "MCTSoundManager.h"
#import "MCTModel.h"
#import "MCTSettingViewController.h"

@interface MCTPlayViewController () <
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate,
MCTSoundManagerDelegate
>

@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSString *playingStrings;
@property (nonatomic) NSArray *morseCodeArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet FXBlurView *blurView;

@end

@implementation MCTPlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MCTSoundManager sharedManager].delegate = self;
    [self updatePlayerConsole];

    self.blurView.frame = self.view.frame;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * (3.0f / 2),
                                             self.view.frame.size.height);
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

#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.morseCodeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"Default"];
    NSString *morseCode = self.morseCodeArray[indexPath.row];
    NSString *string = [NSString stringWithMorseCode:morseCode];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", string, morseCode];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat blurViewWidth = MAX(self.view.frame.size.width - scrollView.contentOffset.x, 10.0f);
    self.blurView.frame = CGRectMake(0, 0, blurViewWidth, self.blurView.frame.size.height);
}


#pragma mark - IBActions

- (IBAction)playOrPauseButtonTapped:(id)sender
{
    NSLog(@"play or pause button");

    if (![MCTSoundManager sharedManager].settedSound) {
        self.playingStrings = [MCTModel sharedModel].strings;
        [[MCTSoundManager sharedManager] setWpm:[MCTModel sharedModel].wpm];
        [[MCTSoundManager sharedManager] setFrequency:[MCTModel sharedModel].frequency];
        [[MCTSoundManager sharedManager] preSetSound:self.playingStrings];
        [self updateTableView];
    }

    [[MCTSoundManager sharedManager] playOrPauseSound];
    [self updatePlayerConsole];
}

#pragma mark - Getter / Setter

- (void)setPlayingStrings:(NSString *)strings
{
    _playingStrings = strings;
    self.morseCodeArray = [strings morseCodeArrayWithString];
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

- (void)updateTableView
{
    [self.tableView reloadData];
}

#pragma mark - MCTSoundManagerDelegate

- (void)soundDidFinishPlaying:(NSString *)soundString
{
    NSLog(@"\"%@\" was played.", soundString);
    [self updatePlayerConsole];
}

@end
