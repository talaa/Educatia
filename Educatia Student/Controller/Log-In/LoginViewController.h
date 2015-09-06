//
//  LoginViewController.h
//  Educatia Student
//
//  Created by MAC on 9/3/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@protocol LoginViewControllerDelegate <NSObject>
- (void)loginViewControllerDidLogin:(LoginViewController *)controller;
@end

@interface LoginViewController : UIViewController

@property (weak, nonatomic) id<LoginViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)signupPress:(id)sender;
- (IBAction)loginPressed:(id)sender;
- (IBAction)forgotPasswordPressed:(id)sender;
@end
