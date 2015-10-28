//
//  LoginViewController.m
//  Educatia Student
//
//  Created by MAC on 9/3/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"
#import "ForgotPasswordViewController.h"
#import <Parse/Parse.h>
#import "ManageLayerViewController.h"

@interface LoginViewController () <UIAlertViewDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.usernameTextField.placeholder = self.usernameTextFieldPlaceHolderString;
    self.passwordTextField.placeholder = self.passwordTextfieldPlaceHolderString;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)signupPress:(id)sender{
    //[self presentSignUpViewController];
}


#pragma mark Delegate

- (void)newUserViewControllerDidSignup:(SignupViewController *)controller {
    
}

#pragma mark - Login Pressed Action

- (IBAction)loginPressed:(id)sender {
    if (self.usernameTextField.text.length > 0 && self.passwordTextField.text.length >0) {
        [PFUser logInWithUsernameInBackground:self.usernameTextField.text  password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
            if (user) {
                //set Data Parsing Object
                [ManageLayerViewController setDataParsingCurrentUserObject:user];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController *vc = (UITabBarController *)[storyboard instantiateViewControllerWithIdentifier:@"UserTabBarController"];
                [self presentViewController:vc animated:YES completion:nil];
            } else {
                // The login failed. Check error to see why.
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Educatia Student" message:@"username or password is not correct.Try again!!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Educatia Student" message:@"Make sure that you have entred all fields" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

# pragma mark - ForgotPassword Action

- (IBAction)forgotPasswordPressed:(id)sender {
    //ForgotPasswordViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ForgotPasswordViewController * forgotPasswordVC = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self presentViewController:forgotPasswordVC animated:YES completion:nil];
}

- (IBAction)cancelPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegete

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SignupSegue"]){
        SignupViewController *signupVC = segue.destinationViewController;
        if ([self.usernameTextFieldPlaceHolderString isEqualToString:@"Student Username"]){
            signupVC.typeIndex = 1;
        }else {
            signupVC.typeIndex = 0;
        }
        
    }
}


@end
