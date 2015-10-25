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
#import "ManageLayerViewController.h"


@interface ProfileViewController () <UIActionSheetDelegate, UIActionSheetDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    PFUser *user;
    UIImage *defaultProfilePicture;
    UIImage *currentProfileImage;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Init BirthDate
    self.flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view];
    self.flatDatePicker.delegate = self;
    self.flatDatePicker.title = @"Select your birthday";
    
    defaultProfilePicture = [UIImage imageNamed:@"Image_AddProfilPic"];
    
    
    //Stop and hidden EditProfileActivityIndicator
    [self hideandStopActivity];
    
    //PFUser Init && PFFile
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
    [self showAndPlayActivity];
    self.usernameTextField.text = user.username;
    self.emailTextField.text = user.email;
    //NSLog(@"Object ID is :%@",user.objectId);
    self.firstNameTextField.text = user[@"FirstName"];
    self.lastNameTextField.text = user[@"LastName"];
    self.phoneTextField.text = user[@"Phone"];
    self.birthDateTextField.text = user[@"DateofBirth"];
    //NSLog(@"Birth is %@", user[@"DateofBirth"]);
    
    //ProfilePicture Layer
    [ManageLayerViewController imageViewLayerProfilePicture:self.profilePictureImageView Corner:75.0f];
    
    if (self.profilePictureImageView.image == nil){
    //retrieve user image
    
    PFFile *userImageFile = user[@"profilePicture"];
    //if condition if there is no user's image
    if (userImageFile == nil){
        self.profilePictureImageView.image = defaultProfilePicture;
        [self showUploadButtonHidechangeProfileButton];
        [self hideandStopActivity];
    }else{
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                self.profilePictureImageView.image = image;
                currentProfileImage = image;
                [self showChangeProfileButtonHideUploadButton];
                [self hideandStopActivity];
            }
        }];
    }
    }
}

//Logout Button Pressed Action
- (IBAction)logoutPressed:(id)sender {
    UIActionSheet *logoutActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:@"Cancel",nil];
    logoutActionSheet.tag = 100;
    [logoutActionSheet showInView:self.view];
}

- (IBAction)calendarPressed:(id)sender {
    [self.birthDateTextField resignFirstResponder];
    static int count = 0;
    count ++;
    if(count % 2 != 0){
        //show
        [self.flatDatePicker show];
    }else{
        //hide
        [self.flatDatePicker dismiss];
    }
}

- (IBAction)editProfilePressed:(id)sender {
    UIActionSheet *requestEditingActionSheet = [[UIActionSheet alloc] initWithTitle:@"Edite my data" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
    requestEditingActionSheet.tag = 200;
    [requestEditingActionSheet showInView:self.view];
    
}

- (IBAction)uploadPhotoPressed:(id)sender {
    [self actionSheetToUploadOrChangeProfilePicture];
}

- (IBAction)changeProfilePicturePressed:(id)sender {
    [self actionSheetToUploadOrChangeProfilePicture];
}

// UIActionSheet to upload and change profile picture
- (void)actionSheetToUploadOrChangeProfilePicture {
    UIActionSheet *changeProfilePictureActionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take Photo" otherButtonTitles:@"Upload from photos", nil];
    changeProfilePictureActionsheet.tag = 300;
    [changeProfilePictureActionsheet showInView:self.view];
}

#pragma mark - UIActionsheet delegete

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //RequestEditingProfileActionSheet
    if (actionSheet.tag == 200) {
        //NSLog(@"Button Index %ld", (long)buttonIndex);
        if (buttonIndex == 0){ //press OK button
            [self showAndPlayActivity];
            [user setObject:self.firstNameTextField.text forKey:@"FirstName"];
            [user setObject:self.lastNameTextField.text forKey:@"LastName"];
            [user setObject:self.phoneTextField.text forKey:@"Phone"];
            [user setObject:self.birthDateTextField.text forKey:@"DateofBirth"];
            
            if (self.profilePictureImageView.image != defaultProfilePicture && self.profilePictureImageView.image != currentProfileImage){
                NSData *imageData = UIImageJPEGRepresentation(self.profilePictureImageView.image, 1.0);
                PFFile *imageFile = [PFFile fileWithName:[self.usernameTextField.text stringByAppendingString:@"_image.png"] data:imageData];
                [imageFile saveInBackground];
                [user setObject:imageFile forKey:@"profilePicture"];
            }
            
            // Save
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self hideandStopActivity];
                    [[[UIAlertView alloc]initWithTitle:@"EducationStudent" message:@"Your profile has been modified successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                }else{
                    [self hideandStopActivity];
                    [[[UIAlertView alloc]initWithTitle:@"EducationStudent" message:[error description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                }
            }];
        }else { //Cancel button pressed
        }
    }
    
    //LogoutActionSheet
    if (actionSheet.tag == 100){
        if (buttonIndex == 0){
            [PFUser logOut];
            [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            [self presentViewController:login animated:YES completion:nil];
            }
        }
    
    //ChangeProfilePictureActionSheet
    if (actionSheet.tag == 300) {
        if (buttonIndex == 0){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
            }];
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
    if (imageData.length > 55500000){
        self.profilePictureImageView.image = defaultProfilePicture;
        [[[UIAlertView alloc] initWithTitle:@"EducationStudent" message:@"Picture you have choosen is greater than 400K!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }else {
        self.profilePictureImageView.image = chosenImage;
        [ManageLayerViewController imageViewLayerProfilePicture:self.profilePictureImageView Corner:75.0f];
        [self showChangeProfileButtonHideUploadButton];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UploadButton and ChangeProfileButton behaviour

- (void)showUploadButtonHidechangeProfileButton {
    self.uploadPhotoButton.hidden           = NO;
    self.changeProfilePictureButton.hidden  = YES;
}

- (void)showChangeProfileButtonHideUploadButton {
    self.uploadPhotoButton.hidden           = YES;
    self.changeProfilePictureButton.hidden  = NO;
}

#pragma mark - FlatDatePicker Delegate

- (void)flatDatePicker:(FlatDatePicker*)datePicker dateDidChange:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString *value = [dateFormatter stringFromDate:date];
    
    self.birthDateTextField.text = value;
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didCancel:(UIButton*)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FlatDatePicker" message:@"Did cancelled !" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didValid:(UIButton*)sender date:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString *value = [dateFormatter stringFromDate:date];
    
    self.birthDateTextField.text = value;
    
    NSString *message = [NSString stringWithFormat:@"Did valid date : %@", value];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FlatDatePicker" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}


@end
