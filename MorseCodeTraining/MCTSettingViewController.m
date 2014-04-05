//
//  MCTSettingViewController.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/20.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTSettingViewController.h"

#import "MCTSettingViewControllerProtocol.h"
#import "MCTMorseCodeSettingModel.h"

@interface MCTSettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *wordLengthValue;
@property (weak, nonatomic) IBOutlet UILabel *wordCountValue;
@property (weak, nonatomic) IBOutlet UILabel *wpmValue;
@property (weak, nonatomic) IBOutlet UILabel *frequencyValue;

@end

@implementation MCTSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.wordLengthValue.text = [NSString stringWithFormat:@"%ld",
                                 (long)[MCTMorseCodeSettingModel settingedValueWithType:MCTMorseCodeSettingTypeWordLength]];
    self.wordCountValue.text = [NSString stringWithFormat:@"%ld",
                                (long)[MCTMorseCodeSettingModel settingedValueWithType:MCTMorseCodeSettingTypeWordCount]];
    self.wpmValue.text = [NSString stringWithFormat:@"%ldWPM",
                          (long)[MCTMorseCodeSettingModel settingedValueWithType:MCTMorseCodeSettingTypeWpm]];
    self.frequencyValue.text = [NSString stringWithFormat:@"%ldHz",
                                (long)[MCTMorseCodeSettingModel settingedValueWithType:MCTMorseCodeSettingTypeFrequency]];
}

#pragma mark - Table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController<MCTSettingViewControllerProtocol> *newViewController = [segue destinationViewController];
    newViewController.settingTarget = segue.identifier;
}

@end
