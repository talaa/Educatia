//
//  SignupViewController.m
//  Educatia Student
//
//  Created by MAC on 9/3/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController () <UITextFieldDelegate>

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self stopActivityIndicator];
    [self.firstNameTextField addTarget:self action:@selector(checkTextField:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitPressed:(id)sender {
    [self startActivityIndicator];
    
    if (self.firstNameTextField.text.length >0 && self.lastNameTextField.text.length >0 && self.usernameTextField.text.length >0 && self.passwordTexrField.text.length >0 && self.confirmPasswordTextField.text.length >0 && self.phoneTextField.text.length >0 && self.emailTextField.text.length >0 && self.emailTextField.text.length >0){
        if ([self.passwordTexrField.text compare:self.confirmPasswordTextField.text] == NSOrderedSame){
            self.firstNameString    = self.firstNameTextField.text;
            self.lastNameString     = self.lastNameTextField.text;
            self.usernameString     = self.usernameTextField.text;
            self.passwordString     = self.passwordTexrField.text;
            self.phoneString        = self.phoneTextField.text;
            self.emailString        = self.emailTextField.text;
            
            //Parse Implementation
            [self parseSavingData];
        }else{
            [self stopActivityIndicator];
            [[[UIAlertView alloc] initWithTitle:@"Education Student" message:@"Kindly entre the same password!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }else{
        [self stopActivityIndicator];
        [[[UIAlertView alloc]initWithTitle:@"Education Student" message:@"Kindly make sure type all mandatory data!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

-(IBAction)dismissViewControllerPressed:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ActivityIndicator Behaviour

- (void)stopActivityIndicator {
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidden = YES;
}

- (void)startActivityIndicator {
    [self.activityIndicatorView startAnimating];
    self.activityIndicatorView.hidden = NO;
}

#pragma mark - TextField real time check

-(void)checkTextField:(id)sender {
    if (self.firstNameTextField.text.length < 4){
         NSLog(@"Check is Okay");
    }else {
        //self.firstNameTextField.text = self.firstNameString;
    }
}

#pragma mark - ParseSavingData

- (void)parseSavingData {
    PFUser *user = [PFUser user];
    user.username = self.usernameString;
    user.email = self.emailString;
    user.password = self.passwordString;
    
    // other fields can be set just like with PFObject
    user[@"Phone"] = self.phoneString;
    user[@"FirstName"] = self.firstNameString;
    user[@"LastName"] = self.lastNameString;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            [self stopActivityIndicator];
            [[[UIAlertView alloc] initWithTitle:@"Education Student" message:@"Well Done.Have a nice time with our app" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        } else {   NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            [self stopActivityIndicator];
            [[[UIAlertView alloc] initWithTitle:@"Education Student" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }];
}
@end
