//
//  RMCustomViewActionController.m
//  RMActionController-Demo
//
//  Created by Roland Moers on 17.05.15.
//  Copyright (c) 2015 Roland Moers. All rights reserved.
//

#import "RMCustomViewActionController.h"

@implementation RMCustomViewActionController

#pragma mark - Init and Dealloc
- (instancetype)initWithStyle:(RMActionControllerStyle)aStyle title:(NSString *)aTitle message:(NSString *)aMessage selectAction:(RMAction *)selectAction andCancelAction:(RMAction *)cancelAction {
    self = [super initWithStyle:aStyle title:aTitle message:aMessage selectAction:selectAction andCancelAction:cancelAction];
    if(self) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        //Title TextField
        UITextField *titleTextfield = [[UITextField alloc] initWithFrame:CGRectZero];
        titleTextfield.translatesAutoresizingMaskIntoConstraints = NO;
        titleTextfield.placeholder = @"News Title";
        titleTextfield.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:titleTextfield];
        
        //News Textfield
        UITextView *textTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        textTextView.translatesAutoresizingMaskIntoConstraints = NO;
        textTextView.layer.borderWidth = 1.0f;
        textTextView.layer.borderColor = [UIColor grayColor].CGColor;
        textTextView.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:textTextView];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:titleTextfield attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:titleTextfield attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-20]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:textTextView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:textTextView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:20]];
        
        NSDictionary *bindings = @{@"contentView": self.contentView};
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[contentView(>=300)]" options:0 metrics:nil views:bindings]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView(140)]" options:0 metrics:nil views:bindings]];
    }
    return self;
}

@end
