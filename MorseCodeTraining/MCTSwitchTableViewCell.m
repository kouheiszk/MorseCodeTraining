//
//  MCTSwitchTableViewCell.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/02/09.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTSwitchTableViewCell.h"

@implementation MCTSwitchTableViewCell

- (IBAction)changedSwithValue:(id)sender
{
    UITableView *tableView = [self findUITableViewFromSuperViewsForView:sender];
    UITableViewCell *cell = [self findUITableViewCellFromSuperViewsForView:sender];
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(tableView:changeSwitchValue:indexPath:)]) {
        [self.delegate tableView:tableView changeSwitchValue:self.valueSwitch.on indexPath:indexPath];
    }
}

- (UITableView *)findUITableViewFromSuperViewsForView:(id)view {
    if (![view isKindOfClass:[UIView class]]) return nil;
    UIView *superView = view;
    while ([superView isKindOfClass:[UITableView class]] == NO) {
        superView = [superView superview];
    }
    return (UITableView *)superView;
}

- (MCTSwitchTableViewCell *)findUITableViewCellFromSuperViewsForView:(id)view
{
    if (![view isKindOfClass:[UIView class]]) return nil;
    UIView *superView = view;
    while ([superView isKindOfClass:[MCTSwitchTableViewCell class]] == NO) {
        superView = [superView superview];
    }
    return (MCTSwitchTableViewCell *)superView;
}

@end
