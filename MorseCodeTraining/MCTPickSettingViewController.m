//
//  MCTPickSettingViewController.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/04/03.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTPickSettingViewController.h"

#import "MCTPickerTableViewCell.h"
#import "MCTPickerDecideTableViewCell.h"
#import "MCTMorseCodeSettingModel.h"

typedef NS_ENUM(NSInteger, MCTPickSettingViewSection) {
    MCTPickSettingViewSectionPicker = 0,
    MCTPickSettingViewSectionDecidion,
};

@interface MCTPickSettingViewController () <MCTPickerTableViewCellDelegate>

@property (nonatomic) MCTMorseCodeSettingType type;
@property (nonatomic) NSArray *options;

@end

@implementation MCTPickSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Table view settings
    self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"MCTPickerTableViewCell" bundle:nil]
         forCellReuseIdentifier:MCTPickerTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"MCTPickerDecideTableViewCell" bundle:nil]
         forCellReuseIdentifier:MCTPickerDecideTableViewCellIdentifier];

    // Table view datasource
    self.type = [MCTMorseCodeSettingModel typeWithTypeString:self.settingTarget];
    self.options = [MCTMorseCodeSettingModel optionsWithType:self.type];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private method

- (void)updatePickCell:(MCTPickerTableViewCell *)cell atIndexPath:(__attribute__((unused)) NSIndexPath *)indexPath
{
    NSInteger defalutOption = [MCTMorseCodeSettingModel settingedValueWithType:self.type];
    cell.options = self.options;
    cell.defaultOption = defalutOption;
    cell.delegate = self;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // MCTPickSettingViewSectionPicker + MCTPickSettingViewSectionDecidion
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == MCTPickSettingViewSectionDecidion) return nil;

    switch (self.type) {
        case MCTMorseCodeSettingTypeWordLength:
            return @"単語の文字数";
        case MCTMorseCodeSettingTypeWordCount:
            return @"単語数";
        case MCTMorseCodeSettingTypeWpm:
            return @"速度";
        case MCTMorseCodeSettingTypeFrequency:
            return @"周波数";
        case MCTMorseCodeSettingTypeNone:
            return nil;
    }

    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == MCTPickSettingViewSectionPicker) {
        MCTPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MCTPickerTableViewCellIdentifier];
        [self updatePickCell:cell atIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.section == MCTPickSettingViewSectionDecidion) {
        MCTPickerDecideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MCTPickerDecideTableViewCellIdentifier];
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == MCTPickSettingViewSectionPicker) {
        MCTPickerTableViewCell *cell = (MCTPickerTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }

    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == MCTPickSettingViewSectionDecidion) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - MCTPickerTableViewCellDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Change picker %@: %@", self.settingTarget, self.options[row]);
    [MCTMorseCodeSettingModel type:self.type settingValue:[self.options[row] integerValue]];
}

@end
