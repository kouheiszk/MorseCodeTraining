//
//  MCTPickerTableViewCell.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/04/05.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTPickerTableViewCell.h"

NSString *const MCTPickerTableViewCellIdentifier = @"MCTPickerTableViewCell";

@interface MCTPickerTableViewCell () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation MCTPickerTableViewCell

- (void)awakeFromNib
{
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.showsSelectionIndicator = YES;
    self.unit = nil;
}

#pragma mark - UIPickerView

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{

}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.options.count;
}

#pragma mark - Getter / Setter

- (CGFloat)height
{
    return 212.f;
}

- (void)setDefaultOption:(NSInteger)defaultOption
{
    _defaultOption = defaultOption;
    NSInteger key = [self.options indexOfObject:@(defaultOption)];
    [self.picker selectRow:key inComponent:0 animated:NO];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *unit = self.unit ? self.unit : @"";
    return [NSString stringWithFormat:@"%@ %@", self.options[row], unit];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:pickerView didSelectRow:row inComponent:component];
    }
}

@end
