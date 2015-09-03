//
//  LoginViewController.m
//  Educatia Student
//
//  Created by MAC on 9/3/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"

@interface LoginViewController () <SignupViewControllerDelegate>

@end

@implementation LoginViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
//    SignupViewController *viewController = [[SignupViewController alloc] init];
//   // viewController.delegate = self;
//    [self presentViewController:viewController animated:YES completion:nil];
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    SignupViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark Delegate

- (void)newUserViewControllerDidSignup:(SignupViewController *)controller {
    
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
