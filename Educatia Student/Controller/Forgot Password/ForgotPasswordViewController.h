//
//  ForgotPasswordViewController.h
//  Educatia Student
//
//  Created by MAC on 9/6/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *emailActivityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *requestNewPasswordButton;
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView;

-(IBAction)dismissViewControllerPressed:(id)sender;
-(IBAction)requestNewPasswordPressed:(id)sender;

@end
