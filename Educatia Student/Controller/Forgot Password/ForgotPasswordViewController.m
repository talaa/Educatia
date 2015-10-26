//
//  ForgotPasswordViewController.m
//  Educatia Student
//
//  Created by MAC on 9/6/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import <Parse/Parse.h>

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //hidden CheckMark Image view
    self.checkMarkImageView.hidden = YES;
    
    //ActiviyIndicator Stop
    [self stopHiddenActivity];
    
    //requestBuuton deactivate
    [self.requestNewPasswordButton setEnabled:NO];
    
    //Deticate emailTextfield input life
    [self.emailTextField addTarget:self action:@selector(checkTextField:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)dismissViewControllerPressed:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)requestNewPasswordPressed:(id)sender {
    [PFUser requestPasswordResetForEmailInBackground:self.emailTextField.text block:^(BOOL succeeded, NSError *error){
        if (error){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Educatia Student" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
        }else {
            NSString *message =@"Link to reset your password has been sent to your email";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Educatia Student" message:message preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

#pragma mark - TextField real time check

-(void)checkTextField:(id)sender {
    [self playShowActivity];
    if ([self validEmail:self.emailTextField.text] == YES){
        [self stopHiddenActivity];
        self.checkMarkImageView.hidden = NO;
        [self.requestNewPasswordButton setEnabled:YES];
    }else{
        //[[[UIAlertView alloc] initWithTitle:@"Education Student" message:@"Kindly type a valid mail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (BOOL) validEmail:(NSString*) emailString {
    if([emailString length]==0){
        return NO;
    }
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    //NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - ActivityIndicator Behaviour

- (void)stopHiddenActivity {
    [self.emailActivityIndicatorView stopAnimating];
    self.emailActivityIndicatorView.hidden = YES;
}

- (void)playShowActivity {
    self.emailActivityIndicatorView.hidden = NO;
    [self.emailActivityIndicatorView startAnimating];
}

# pragma mark - UIAlertViewActionDelegete

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else{
        //reset clicked
    }
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
