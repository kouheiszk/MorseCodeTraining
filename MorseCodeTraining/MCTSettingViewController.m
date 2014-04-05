//
//  MCTSettingViewController.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/01/20.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTSettingViewController.h"

#import "MCTSettingViewControllerProtocol.h"

@interface MCTSettingViewController ()

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
