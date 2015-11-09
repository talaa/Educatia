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
    self.flatDatePicker.maximumDate = [NSDate date];
    
    defaultProfilePicture = [UIImage imageNamed:@"Image_AddProfilPic"];
    
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

    self.firstNameTextField.text = user[@"FirstName"];
    self.lastNameTextField.text = user[@"LastName"];
    self.phoneTextField.text = user[@"Phone"];
    self.birthDateTextField.text = user[@"DateofBirth"];
    
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Educatia Student" message:@"Picture you have choosen is greater than 400K!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
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
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didCancel:(UIButton*)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"FlatDataPicker" message:@"Did cancelled" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didValid:(UIButton*)sender date:(NSDate*)date {
    UIAlertController *alertController;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString *value = [dateFormatter stringFromDate:date];
    if (date >= [NSDate date]){
        NSString *message = [NSString stringWithFormat:@"Incorrect Birthdate : %@", value];
        alertController = [UIAlertController alertControllerWithTitle:@"Incorrect Birth Date" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:okAction];
    }else {
        self.birthDateTextField.text = value;
        NSString *message = [NSString stringWithFormat:@"Did valid date : %@", value];
         alertController = [UIAlertController alertControllerWithTitle:@"Birth Date" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:okAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
