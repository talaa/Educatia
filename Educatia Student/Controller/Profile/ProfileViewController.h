//
//  ProfileViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 9/8/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatDatePicker.h"

@interface ProfileViewController : UIViewController <UITextFieldDelegate,FlatDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *changeProfilePictureButton;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthDateTextField;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadPhotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (nonatomic, strong) FlatDatePicker *flatDatePicker;

- (IBAction)logoutPressed:(id)sender;
- (IBAction)calendarPressed:(id)sender;
- (IBAction)editProfilePressed:(id)sender;
- (IBAction)uploadPhotoPressed:(id)sender;
- (IBAction)changeProfilePicturePressed:(id)sender;

@end
