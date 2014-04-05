//
//  MCTSwitchTableViewCell.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/02/09.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const MCTSwitchTableViewCellIdentifier;

@protocol MCTSwitchTableViewCellDelegate;

@interface MCTSwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) UIViewController<MCTSwitchTableViewCellDelegate> *delegate;

@property (weak, nonatomic) IBOutlet UISwitch *valueSwitch;
@property (weak, nonatomic, readonly) IBOutlet UILabel *textLabel;

@end


@protocol MCTSwitchTableViewCellDelegate

- (void)tableView:(UITableView *)tableView changeSwitchValue:(BOOL)on indexPath:(NSIndexPath *)indexPath;

@end
