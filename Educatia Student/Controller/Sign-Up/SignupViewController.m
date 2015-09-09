//
//  SignupViewController.m
//  Educatia Student
//
//  Created by MAC on 9/3/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>


@interface SignupViewController () <UITextFieldDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate>

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Hide and stop ActivityIndicator --> Submit
    [self stopActivityIndicator];
    
    //Hide emailActivityIndicator && hide emailImageTrue
    [self hideEmailActivityIndicatorHideEmailImage];
    
    //Init BirthDate
    self.flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view];
    self.flatDatePicker.delegate = self;
    self.flatDatePicker.title = @"Select your birthday";
    
    //Deticate emailTextfield input life
    [self.emailTextField addTarget:self action:@selector(checkTextField:) forControlEvents:UIControlEventEditingChanged];
    
    //dismiss keyboard &&activityIndicator email when pressed outside it
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(hiddenEmailActivityIndicatorAndDismissKeybad)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [self isPicProfileImageViewEmpty];
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
    UIImage *picture = [UIImage imageNamed:@"Image_AddProfilPic"];
    if ([self.picProfileImageView.image isEqual:picture]){
        //no image set
        return YES;
    }
    else{
        return NO;
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

- (IBAction)submitPressed:(id)sender {
    [self startActivityIndicator];
    
    if (self.firstNameTextField.text.length >0 && self.lastNameTextField.text.length >0 && self.usernameTextField.text.length >0 && self.passwordTexrField.text.length >0 && self.confirmPasswordTextField.text.length >0 && self.phoneTextField.text.length >0 && self.emailTextField.text.length >0 && self.emailTextField.text.length >0 && self.birthdateTextField.text.length >0){
        if ([self.passwordTexrField.text compare:self.confirmPasswordTextField.text] == NSOrderedSame){
            self.firstNameString    = self.firstNameTextField.text;
            self.lastNameString     = self.lastNameTextField.text;
            self.usernameString     = self.usernameTextField.text;
            self.passwordString     = self.passwordTexrField.text;
            self.phoneString        = self.phoneTextField.text;
            self.emailString        = self.emailTextField.text;
            self.birthdayString       = self.birthdateTextField.text;
            
            //Parse Implementation
            [self parseSavingData];
        }else{
            [self stopActivityIndicator];
            [[[UIAlertView alloc] initWithTitle:@"Education Student" message:@"Kindly entre the same password!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }else{
        [self stopActivityIndicator];
        [[[UIAlertView alloc]initWithTitle:@"Education Student" message:@"Kindly make sure type all mandatory data!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
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
    user.username = self.usernameString;
    user.email = self.emailString;
    user.password = self.passwordString;
    
    //Save profile pic image if exist
    if ([self isPicProfileImageViewEmpty] == YES) {
        //don't save because there is no image is uploaded
    }else { //user has uploaded an image then save it
        NSString *userImageName = [self.usernameString stringByAppendingString:@"_image.png"];
        NSData *imageData = UIImagePNGRepresentation(self.picProfileImageView.image);
        PFFile *imageFile = [PFFile fileWithName:userImageName data:imageData];
        user[@"profilePicture"] = imageFile;
    }
    
    // other fields can be set just like with PFObject
    user[@"Phone"]          = self.phoneString;
    user[@"FirstName"]      = self.firstNameString;
    user[@"LastName"]       = self.lastNameString;
    user[@"DateofBirth"]    = self.birthdayString;
    
    
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString *value = [dateFormatter stringFromDate:date];
    
    self.birthdateTextField.text = value;
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
    
    self.birthdateTextField.text = value;
    
    NSString *message = [NSString stringWithFormat:@"Did valid date : %@", value];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FlatDatePicker" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

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
    //Check if picture size is greater than 400K
    NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((chosenImage),1.0)];
    //NSLog(@"Image size is %lu", (unsigned long)imageData.length);
    if (imageData.length > 500000){
        self.picProfileImageView.image = [UIImage imageNamed:@"Image_AddProfilPic"];
        [[[UIAlertView alloc] initWithTitle:@"EducationStudent" message:@"Picture you have choosen is greater than 400K!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }else {
        //hide uploadProfileButton
        self.uploadPhotoButton.hidden = YES;
        
        //picProfileImageView Layout
        self.picProfileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.picProfileImageView.layer.borderWidth = 1.5f;
        self.picProfileImageView.layer.cornerRadius = 7.0f;
        self.picProfileImageView.layer.masksToBounds = YES;
        self.picProfileImageView.image = chosenImage;
    }
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


@end
