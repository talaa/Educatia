//
//  MainViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/7/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "MainViewController.h"
#import "ManageLayerViewController.h"
#import "LoginViewController.h" 
#import "CHTransitionAnimationController.h"

@interface MainViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ManageLayerViewController buttonLayerMainView:self.studentButton];
    [ManageLayerViewController buttonLayerMainView:self.teacherButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    LoginViewController *loginVC    = segue.destinationViewController;
    loginVC.transitioningDelegate   = self;
    if ([segue.identifier isEqualToString:@"StudentSegue"]) {
        loginVC.usernameTextFieldPlaceHolderString = @"Student Username";
        loginVC.passwordTextfieldPlaceHolderString = @"Student Password";
    }
    
    if ([segue.identifier isEqualToString:@"TeacherSegue"]) {
        loginVC.usernameTextFieldPlaceHolderString = @"Teacher Username";
        loginVC.passwordTextfieldPlaceHolderString = @"Teacher Password";
    }
}


- (IBAction)studentButtonPressed:(id)sender {
}

- (IBAction)teacherButtonPressed:(id)sender {
}

#pragma mark - Transitioning Delegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                 presentingController:(UIViewController *)presenting
                                                                     sourceController:(UIViewController *)source
{
    
    CHTransitionAnimationController *animationController = [CHTransitionAnimationController new];
    animationController.animationType = CHTransitionAnimationTypeShrinkWithRotation;
    animationController.animationDuration = .25;	//optional setting here - defaults to 0.25
    return animationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    CHTransitionAnimationController *animationController = [CHTransitionAnimationController new];
    animationController.animationType = CHTransitionAnimationTypeSlideOutToBottom;
    animationController.animationDuration = .25;	//optional setting here - defaults to 0.25
    return animationController;
}

@end
