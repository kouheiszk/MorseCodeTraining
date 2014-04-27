//
//  MCTHorizontalScrollView.m
//  MorseCodeTraining
//
//  Created by Suzuki Kouhei on 2014/04/27.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTHorizontalScrollView.h"

@implementation MCTHorizontalScrollView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *subview in self.subviews) {
        if (CGRectContainsPoint([subview frame], point))
            return subview;
    }
    return self;
}

@end
