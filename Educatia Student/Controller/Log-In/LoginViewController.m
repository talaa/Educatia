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

@interface LoginViewController () <SignupViewControllerDelegate,UIAlertViewDelegate>

@end

@implementation LoginViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self presentSignUpViewController];
}

#pragma mark NewUserViewController

- (void)presentSignUpViewController {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    SignupViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark Delegate

- (void)newUserViewControllerDidSignup:(SignupViewController *)controller {
    
}

#pragma mark - Login Pressed Action

- (IBAction)loginPressed:(id)sender {
    if (self.usernameTextField.text.length > 0 && self.passwordTextField.text.length >0) {
        [PFUser logInWithUsernameInBackground:self.usernameTextField.text  password:self.passwordTextField.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                // Do stuff after successful login.
                                                //Turned to Tabbar controller
                                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                UITabBarController *vc = (UITabBarController *)[storyboard instantiateViewControllerWithIdentifier:@"TabBarHolderController"];
                                                [self presentViewController:vc animated:YES completion:nil];
                                            } else {
                                                // The login failed. Check error to see why.
                                                [[[UIAlertView alloc] initWithTitle:@"Education Student" message:@"username or password is not correct.Try again!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                                            }
                                        }];

    }else{
        [[[UIAlertView alloc] initWithTitle:@"Education Student" message:@"Make sure that you have entred all fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

# pragma mark - ForgotPassword Action

- (IBAction)forgotPasswordPressed:(id)sender {
    //ForgotPasswordViewController
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    ForgotPasswordViewController * forgotPasswordVC = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self presentViewController:forgotPasswordVC animated:YES completion:nil];

}

#pragma mark - UIAlertViewDelegete

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (alertView.tag == 100){
//        if (buttonIndex == 0) {
//            
//        }
//    }
    
//
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
