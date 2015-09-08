//
//  ProfileViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 9/8/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//
#import <Parse/Parse.h>
#import "ProfileViewController.h"

@interface ProfileViewController () <UIActionSheetDelegate>

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Logout Button Pressed Action
- (IBAction)logoutPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:@"Cancel",nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionsheet delegete

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index %ld", (long)buttonIndex);
    if (buttonIndex == 0){
        [PFUser logOut];
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *LoginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        [self presentViewController:LoginViewController animated:NO completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else { //buttonIndex = 1
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
