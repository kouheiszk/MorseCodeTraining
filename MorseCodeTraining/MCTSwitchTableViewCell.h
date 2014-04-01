//
//  MCTSwitchTableViewCell.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/02/09.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCTSwitchCellDelegate

- (void)tableView:(UITableView *)tableView changeSwitchValue:(BOOL)on indexPath:(NSIndexPath *)indexPath;

@end

@interface MCTSwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) UIViewController<MCTSwitchCellDelegate> *delegate;

@property (weak, nonatomic) IBOutlet UISwitch *valueSwitch;
@property (weak, nonatomic, readonly) IBOutlet UILabel *textLabel;

@end
