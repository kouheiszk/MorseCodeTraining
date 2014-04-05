//
//  MCTPickerTableViewCell.h
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/04/05.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const MCTPickerTableViewCellIdentifier;

@protocol MCTPickerTableViewCellDelegate;

@interface MCTPickerTableViewCell : UITableViewCell

@property (weak, nonatomic) UIViewController<MCTPickerTableViewCellDelegate> *delegate;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic) NSArray *options;
@property (nonatomic) NSInteger defaultOption;
@property (nonatomic) NSString *unit;
@end


@protocol MCTPickerTableViewCellDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end