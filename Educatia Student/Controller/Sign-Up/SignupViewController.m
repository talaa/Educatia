//
//  SignupViewController.m
//  Educatia Student
//
//  Created by MAC on 9/3/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "ManageLayerViewController.h"

@interface SignupViewController () <UITextFieldDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate>

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self isPicProfileImageViewEmpty];
    [self defaultProfileImage];
    
    //Hide and stop ActivityIndicator --> Submit
    [self stopActivityIndicator];
    
    //Hide emailActivityIndicator && hide emailImageTrue
    [self hideEmailActivityIndicatorHideEmailImage];
    
    //Init BirthDate
    self.flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view];
    self.flatDatePicker.delegate = self;
    self.flatDatePicker.title = @"Select your birthday";
    self.flatDatePicker.maximumDate = [NSDate date];
    
    //Deticate emailTextfield input life
    [self.emailTextField addTarget:self action:@selector(checkTextField:) forControlEvents:UIControlEventEditingChanged];
    
    //dismiss keyboard &&activityIndicator email when pressed outside it
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(hiddenEmailActivityIndicatorAndDismissKeybad)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.firstNameTextField.text        = @"";
    self.lastNameTextField.text         = @"";
    self.usernameTextField.text         = @"";
    self.passwordTexrField.text         = @"";
    self.confirmPasswordTextField.text  = @"";
    self.phoneTextField.text            = @"";
    self.birthdateTextField.text        = @"";
    self.emailTextField.text            = @"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (bool)isPicProfileImageViewEmpty {
    //Check if picProfileImageView empty
    UIImage *picture;
    if (_typeIndex == 1){
        picture = [UIImage imageNamed:@"Image_StudentProfile"];
    }else {
        picture = [UIImage imageNamed:@"Image_TeacherProfile"];
    }
    
    if ([self.picProfileImageView.image isEqual:picture]){
        //no image set
        return YES;
    }
    else{
        return NO;
    }
}

- (void)defaultProfileImage {
    UIImage *picture;
    if (_typeIndex == 1){
        picture = [UIImage imageNamed:@"Image_StudentProfile"];
    }else {
        picture = [UIImage imageNamed:@"Image_TeacherProfile"];
    }
    [ManageLayerViewController imageViewLayerProfilePicture:self.picProfileImageView Corner:90.0f];
    self.picProfileImageView.image = picture;
    
    //hide changePhoto and present UploadPhoto
    [self hideChangeButton];
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
    
    if (self.firstNameTextField.text.length >0 && self.lastNameTextField.text.length >0 && self.usernameTextField.text.length >0 && self.passwordTexrField.text.length >0 && self.confirmPasswordTextField.text.length >0 && self.phoneTextField.text.length >0 && self.emailTextField.text.length >0 && self.emailTextField.text.length >0 && self.birthdateTextField.text.length >0){
        if ([self.passwordTexrField.text compare:self.confirmPasswordTextField.text] == NSOrderedSame){
            self.birthdayString     = self.birthdateTextField.text;
            
            //Parse Implementation
            [self parseSavingData];
        }else{
            [self stopActivityIndicator];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Educatia Student" message:@"Kindly entre the same password!" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }else{
        [self stopActivityIndicator];
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"Educatia Student" message:@"Kindly make sure type all mandatory data!" preferredStyle:UIAlertControllerStyleAlert];
        [alertcontroller addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertcontroller animated:YES completion:nil];
    }
}

-(IBAction)dismissViewControllerPressed:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//BirthdateButton Pressed Action
- (IBAction)birthdateCalenderPressed:(id)sender {
    [self.birthdateTextField resignFirstResponder];
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
    [self showEmailActivityIndicatorAndHideEmailImage];
    if ([self validEmail:self.emailTextField.text] == YES){
        [self hideEmailActivityIndicatorShowEmailImage];
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


#pragma mark - ParseSavingData

- (void)parseSavingData {
    PFUser *user = [PFUser user];
    user.username = self.usernameTextField.text;
    user.email = self.emailTextField.text;
    user.password = self.passwordTexrField.text;
    
    //Save profile pic image if exist
    if ([self isPicProfileImageViewEmpty] == YES) {
        //don't save because there is no image is uploaded
    }else { //user has uploaded an image then save it
        NSString *userImageName = [self.usernameTextField.text stringByAppendingString:@"_image.png"];
        NSData *imageData = UIImagePNGRepresentation(self.picProfileImageView.image);
        PFFile *imageFile = [PFFile fileWithName:userImageName data:imageData];
        user[@"profilePicture"] = imageFile;
    }
    
    // other fields can be set just like with PFObject
    user[@"Phone"]          = self.phoneTextField.text;
    user[@"FirstName"]      = self.firstNameTextField.text;
    user[@"LastName"]       = self.lastNameTextField.text;
    user[@"DateofBirth"]    = self.birthdayString;
    
    //check type if student or teacher
    if (_typeIndex == 0) {
        user[@"type"]        = @"Teacher";
    }else {
        user[@"type"]        = @"Student";
    }
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            [self stopActivityIndicator];
            UIAlertView *successSignUpAlertView = [[UIAlertView alloc] initWithTitle:@"Education Student" message:@"Well Done.Have a nice time with our app" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            successSignUpAlertView.tag = 100;
            [successSignUpAlertView show];
        } else {
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            [self stopActivityIndicator];
            [[[UIAlertView alloc] initWithTitle:@"Education Student" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }];
}

#pragma mark - FlatDatePicker Delegate

- (void)flatDatePicker:(FlatDatePicker*)datePicker dateDidChange:(NSDate*)date {
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didCancel:(UIButton*)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"FlatDatePicker" message:@"Did cancelled !" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
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
        self.birthdateTextField.text = value;
        NSString *message = [NSString stringWithFormat:@"Did valid date : %@", value];
        alertController = [UIAlertController alertControllerWithTitle:@"Birth Date" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:okAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];}

#pragma mark - EmailActivityIndicator and ImageTrue Behaviour

- (void)hideEmailActivityIndicatorShowEmailImage {
    [self.emailActivityIndicatorView stopAnimating];
    self.emailActivityIndicatorView.hidden = YES;
    self.emailImageViewTrue.hidden = NO;
}

- (void)hideEmailActivityIndicatorHideEmailImage {
    [self.emailActivityIndicatorView stopAnimating];
    self.emailActivityIndicatorView.hidden = YES;
    self.emailImageViewTrue.hidden = YES;
}

- (void)showEmailActivityIndicatorAndHideEmailImage {
    self.emailImageViewTrue.hidden = YES;
    self.emailActivityIndicatorView.hidden = NO;
    [self.emailActivityIndicatorView startAnimating];
    
}

//dismiss keybad and emailActivityIndicator
- (void)hiddenEmailActivityIndicatorAndDismissKeybad{
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
    [self.passwordTexrField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.birthdateTextField resignFirstResponder];
    self.emailActivityIndicatorView.hidden = YES;
}

//UploadPhtot button pressed action
-(IBAction)uploadPhotoPressed:(id)sender {
    [self actionsheetPresent];
}

- (IBAction)changePhotoPressed:(id)sender {
    [self actionsheetPresent];
}

- (void)actionsheetPresent {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take Photo" otherButtonTitles:@"Upload from photos", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionsheet delegete

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"Button Index %ld", (long)buttonIndex);
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

#pragma mark - UIImagePickerControllerDelegete

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    /*Check Image Size
     //Check if picture size is greater than 400K
     NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((chosenImage),0.5)];
     NSLog(@"Image size is %lu", (unsigned long)imageData.length);
     if (imageData.length > 500000){
     self.picProfileImageView.image = [UIImage imageNamed:@"Image_AddProfilPic"];
     [[[UIAlertView alloc] initWithTitle:@"EducationStudent" message:@"Picture you have choosen is greater than 400K!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }else {}
     */
    //hide uploadProfileButton
    [self hideUploadButton];
    
    //picProfileImageView Layout
    [ManageLayerViewController imageViewLayerProfilePicture:self.picProfileImageView Corner:90.0f];
    self.picProfileImageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIAlertViewDelegete

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // Is this my Alert View?
    if (alertView.tag == 100) {
        if (buttonIndex == 0){
            //Cancelled button has been pressed
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


#pragma mark - ChangeButton && UploadButton behaviour

- (void)hideChangeButton {
    self.changePhotoButton.hidden = YES;
    self.uploadPhotoButton.hidden = NO;
}

- (void)hideUploadButton {
    self.changePhotoButton.hidden = NO;
    self.uploadPhotoButton.hidden = YES;
}

@end
