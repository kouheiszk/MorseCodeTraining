//
//  MCTAlphabetViewController.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/02/09.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTAlphabetViewController.h"

static NSString *const kCellIdentifier = @"MCTSwitchTableViewCell";

@interface MCTAlphabetViewController ()

@property (nonatomic) NSArray *array;

@end

@implementation MCTAlphabetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Table view settings
    self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"MCTSwitchTableViewCell" bundle:nil]
         forCellReuseIdentifier:kCellIdentifier];

    // Table view datasource
    self.array = @[@"A B C",
                   @"D E F",
                   @"G H I",
                   @"J K L",
                   @"M N O",
                   @"P Q R",
                   @"S T U",
                   @"V W X",
                   @"W Z",
                   ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateCell:(MCTSwitchTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = self.array[indexPath.row];
    cell.valueSwitch.on = NO;
    cell.delegate = self;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"アルファベット";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCTSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    [self updateCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MCTSwitchCellDelegate

- (void)tableView:(UITableView *)tableView changeSwitchValue:(BOOL)on indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Change switch %ld: %@", indexPath.row, on ? @"ON" : @"OFF");
}

@end
