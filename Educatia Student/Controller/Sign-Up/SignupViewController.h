//
//  SignupViewController.h
//  Educatia Student
//
//  Created by MAC on 9/3/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignupViewController;
@protocol SignupViewControllerDelegate <NSObject>
@end

@interface SignupViewController : UIViewController

@property (nonatomic, weak) id<SignupViewControllerDelegate> delegate;

-(IBAction)dismissViewControllerPress:(id)sender;
@end
