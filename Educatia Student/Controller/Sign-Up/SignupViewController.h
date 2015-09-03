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

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak) id<SignupViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTexrField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (strong, nonatomic) IBOutlet NSString *firstNameString;
@property (strong, nonatomic) IBOutlet NSString *lastNameString;
@property (strong, nonatomic) IBOutlet NSString *usernameString;
@property (strong, nonatomic) IBOutlet NSString *passwordString;
@property (strong, nonatomic) IBOutlet NSString *confirmPasswordString;
@property (strong, nonatomic) IBOutlet NSString *phoneString;
@property (strong, nonatomic) IBOutlet NSString *emailString;
@property (strong, nonatomic) IBOutlet NSString *addressString;

-(IBAction)submitPressed:(id)sender;
-(IBAction)dismissViewControllerPressed:(id)sender;
@end
