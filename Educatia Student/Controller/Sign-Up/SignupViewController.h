//
//  SignupViewController.h
//  Educatia Student
//
//  Created by MAC on 9/3/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatDatePicker.h"

@class SignupViewController;
@protocol SignupViewControllerDelegate <NSObject>
@end

@interface SignupViewController : UIViewController <FlatDatePickerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *picProfileImageView;
@property (weak, nonatomic) IBOutlet UIButton *uploadPhotoButton;
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
@property (weak, nonatomic) IBOutlet UITextField *birthdateTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *emailActivityIndicatorView;
@property (weak, nonatomic) IBOutlet UIImageView *emailImageViewTrue;

@property (nonatomic, strong) FlatDatePicker *flatDatePicker;
@property (strong, nonatomic) IBOutlet NSString *firstNameString;
@property (strong, nonatomic) IBOutlet NSString *lastNameString;
@property (strong, nonatomic) IBOutlet NSString *usernameString;
@property (strong, nonatomic) IBOutlet NSString *passwordString;
@property (strong, nonatomic) IBOutlet NSString *confirmPasswordString;
@property (strong, nonatomic) IBOutlet NSString *phoneString;
@property (strong, nonatomic) IBOutlet NSString *emailString;
@property (strong, nonatomic) IBOutlet NSString *addressString;
@property (strong, nonatomic) IBOutlet NSString *birthdayString;

-(IBAction)submitPressed:(id)sender;
-(IBAction)dismissViewControllerPressed:(id)sender;
-(IBAction)birthdateCalenderPressed:(id)sender;
-(IBAction)uploadPhotoPressed:(id)sender;

@end
