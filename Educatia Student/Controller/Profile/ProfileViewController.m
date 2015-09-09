//
//  ProfileViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 9/8/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//
#import <Parse/Parse.h>
#import "ProfileViewController.h"
#import "LoginViewController.h"

@interface ProfileViewController () <UIActionSheetDelegate, UIActionSheetDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    PFUser *user;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //ProfilePicture Layout
    self.profilePictureImageView.layer.borderColor      = [UIColor whiteColor].CGColor;
    self.profilePictureImageView.layer.borderWidth      = 1.5f;
    self.profilePictureImageView.layer.cornerRadius     = 7.0f;
    self.profilePictureImageView.layer.masksToBounds    = YES;
    
    //Stop and hidden EditProfileActivityIndicator
    [self hideandStopActivity];
    
    //PFUser Init
    user = [PFUser currentUser];
    
    [self retrievingCurrentUserData];
    
    //dismiss keyboard &&activityIndicator email when pressed outside it
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(DismissKeybad)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//retrieve user's data
-(void)retrievingCurrentUserData {
    self.usernameTextField.text = user.username;
    self.emailTextField.text = user.email;
    NSLog(@"Object ID is :%@",user.objectId);
    self.firstNameTextField.text = user[@"FirstName"];
    self.lastNameTextField.text = user[@"LastName"];
    self.phoneTextField.text = user[@"Phone"];
    self.birthDateTextField.text = user[@"DateofBirth"];
    NSLog(@"Birth is %@", user[@"DateofBirth"]);
    
    //retrieve user
    PFFile *userImageFile = user[@"profilePicture"];
    [self showAndPlayActivity];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            
            UIImage *image = [UIImage imageWithData:imageData];
            self.profilePictureImageView.image = image;
            if ([self.profilePictureImageView.image isEqual:image]){
                self.uploadPhotoButton.hidden = YES;
                self.changeProfilePictureButton.hidden = NO;
                }
                else{
                    [self hideandStopActivity];
                    self.uploadPhotoButton.hidden = NO;
                    self.changeProfilePictureButton.hidden = YES;
                }
            }
        [self hideandStopActivity];
    }];
}

//Logout Button Pressed Action
- (IBAction)logoutPressed:(id)sender {
    UIActionSheet *logoutActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:@"Cancel",nil];
    logoutActionSheet.tag = 100;
    [logoutActionSheet showInView:self.view];
}

- (IBAction)calendarPressed:(id)sender {
}

- (IBAction)editProfilePressed:(id)sender {
    UIActionSheet *requestEditingActionSheet = [[UIActionSheet alloc] initWithTitle:@"Edite my data" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
    requestEditingActionSheet.tag = 200;
    [requestEditingActionSheet showInView:self.view];
    
}

- (IBAction)uploadPhotoPressed:(id)sender {
}

- (IBAction)changeProfilePicturePressed:(id)sender {
    UIActionSheet *changeProfilePictureActionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take Photo" otherButtonTitles:@"Upload from photos", nil];
    changeProfilePictureActionsheet.tag = 300;
    [changeProfilePictureActionsheet showInView:self.view];
}

#pragma mark - UIActionsheet delegete

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //RequestEditingProfileActionSheet
    if (actionSheet.tag == 200) {
        NSLog(@"Button Index %ld", (long)buttonIndex);
        if (buttonIndex == 0){ //press OK button
            [self showAndPlayActivity];
            [user setObject:self.firstNameTextField.text forKey:@"FirstName"];
            [user setObject:self.lastNameTextField.text forKey:@"LastName"];
            [user setObject:self.phoneTextField.text forKey:@"Phone"];
            [user setObject:self.birthDateTextField.text forKey:@"DateofBirth"];
            
            
            // Save
            [user saveInBackground];
            [self hideandStopActivity];
            [self retrievingCurrentUserData];
        }else { //Cancel button pressed
        }
    }
    
    //LogoutActionSheet
    if (actionSheet.tag == 100){
        if (buttonIndex == 0){
            [PFUser logOut];
            [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    
    //ChangeProfilePictureActionSheet
    if (actionSheet.tag == 300) {
        if (buttonIndex == 0){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }else { //buttonIndex = 1
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //your code
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:NULL];
            }];
            
        }

    }
    
}

- (bool)isLoginViewIsPresenting {
    if([self presentingViewController]){
        return YES;
    }else{
        return NO;
    }
    
    //if([[self presentingViewController] presentedViewController] == self)
        //return YES;
    //if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
        //return YES;
    //if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        //return YES;
    
    //return NO;
}

#pragma mark - UITextFieldDelegete

//dismiss keybad
- (void)DismissKeybad {
    [self.firstNameTextField    resignFirstResponder];
    [self.lastNameTextField     resignFirstResponder];
    [self.usernameTextField     resignFirstResponder];
    [self.phoneTextField        resignFirstResponder];
    [self.emailTextField        resignFirstResponder];
    [self.birthDateTextField    resignFirstResponder];
}

// Hide and stop ActivityIndicatoe
- (void)hideandStopActivity {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
}

//Show and Play AcivityIndicator
- (void)showAndPlayActivity {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

#pragma mark - UIImagePickerControllerDelegete

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //Check if picture size is greater than 400K
    NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((chosenImage),1.0)];
    //NSLog(@"Image size is %lu", (unsigned long)imageData.length);
    if (imageData.length > 500000){
        self.profilePictureImageView.image = [UIImage imageNamed:@"Image_AddProfilPic"];
        [[[UIAlertView alloc] initWithTitle:@"EducationStudent" message:@"Picture you have choosen is greater than 400K!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }else {
        //hide uploadProfileButton
        self.uploadPhotoButton.hidden = YES;
        
        //picProfileImageView Layout
        self.profilePictureImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profilePictureImageView.layer.borderWidth = 1.5f;
        self.profilePictureImageView.layer.cornerRadius = 7.0f;
        self.profilePictureImageView.layer.masksToBounds = YES;
        self.profilePictureImageView.image = chosenImage;
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
