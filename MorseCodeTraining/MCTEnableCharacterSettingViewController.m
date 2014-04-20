//
//  MCTEnableCharacterSettingViewController.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/02/09.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTEnableCharacterSettingViewController.h"

#import "MCTSwitchTableViewCell.h"
#import "MCTModel.h"

@interface MCTEnableCharacterSettingViewController () <MCTSwitchTableViewCellDelegate>

@property (nonatomic) MCTMorseCodeCharacterType type;
@property (nonatomic) NSArray *array;

@end

@implementation MCTEnableCharacterSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Table view settings
    self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"MCTSwitchTableViewCell" bundle:nil]
         forCellReuseIdentifier:MCTSwitchTableViewCellIdentifier];

    // Table view datasource
    self.type = [[MCTModel sharedModel].character typeWithTypeString:self.settingTarget];
    self.array = [[MCTModel sharedModel].character charactersWithType:self.type];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (self.type) {
        case MCTMorseCodeCharacterTypeAlphabet:
            return @"アルファベット";
        case MCTMorseCodeCharacterTypeNumber:
            return @"数字";
        case MCTMorseCodeCharacterTypeSymbol:
            return @"記号";
        case MCTMorseCodeCharacterTypeAll:
            return @"すべて";
    }

    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCTSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MCTSwitchTableViewCellIdentifier];
    [self updateCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCTSwitchTableViewCell *cell = (MCTSwitchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.valueSwitch setOn:!cell.valueSwitch.on animated:YES];
    [self tableView:tableView changeSwitchValue:cell.valueSwitch.on indexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private method

- (void)updateCell:(MCTSwitchTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = self.array[indexPath.row];
    cell.valueSwitch.on = [[MCTModel sharedModel].character isEnableCharacter:self.array[indexPath.row]];
    cell.delegate = self;
}

#pragma mark - MCTSwitchTableViewCellDelegate

- (void)tableView:(UITableView *)tableView changeSwitchValue:(BOOL)on indexPath:(NSIndexPath *)indexPath
{
     NSLog(@"Change switch %@: %@", self.array[indexPath.row], on ? @"ON" : @"OFF");
    [[MCTModel sharedModel].character character:self.array[indexPath.row] enable:on];
}

@end
