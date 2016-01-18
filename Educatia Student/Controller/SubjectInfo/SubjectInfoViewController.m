//
//  SubjectInfoViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/15/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "SubjectInfoViewController.h"
#import <Parse/Parse.h>
#import "SubjectObject.h"
#import "SVProgressHUD.h"
#import "ManageLayerViewController.h"
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>

@interface SubjectInfoViewController () <MBProgressHUDDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate>
{
    MBProgressHUD  *HUD;
    bool            isUserTeacher;
}
@end

@implementation SubjectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ManageLayerViewController imageViewLayerProfilePicture:self.subjectLogoImageView Corner:100.0f];
    
    //SendCodeButton Layout
    self.sendCodeButton.layer.cornerRadius = 7.0f;
    self.sendCodeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.sendCodeButton.layer.borderWidth = 2.0f;
    
    //check if subjectLogoImageView presents an image
    //present change button in case of image existing otherwise present uplaod button
    isUserTeacher = [ManageLayerViewController getDataParsingIsCurrentTeacher];
    [self hideLogoButtons];
    
    //Loading
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Loading...";
    
    [self loadSubjectData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    //check if current user is teacher --> enable and present sendCodeButton.Otherwise, hide and disabled
    if ([ManageLayerViewController getDataParsingIsCurrentTeacher]) {
        self.sendCodeButton.hidden      = NO;
        self.sendCodeButton.enabled     = YES;
    }else {
        self.sendCodeButton.hidden      = YES;
        self.sendCodeButton.enabled     = NO;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 *
 ******* Load Subject's Data ********
 *
 */
- (void)loadSubjectData{
    PFQuery *query = [PFQuery queryWithClassName:@"Subjects"];
    [query whereKey:@"objectId" equalTo:[ManageLayerViewController getDataParsingSubjectID]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                self.codeLabel.text = object.objectId;
                self.subjectLabel.text = object[@"subjectName"];
                self.teacherLabel.text = object[@"teacherFullName"];
                //load image
                PFFile *subjectLogoFile = object[@"subjectLogo"];
                if (subjectLogoFile == nil){
                    if (isUserTeacher){
                        [self imageNotExistPresentUploadButton];
                    }else{
                    }
                }else {
                    [subjectLogoFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                        if (!error) {
                            self.subjectLogoImageView.image = [UIImage imageWithData:imageData];
                            if (isUserTeacher){
                                [self imageExistPresentChangeButton];
                            }
                            
                        }
                    }];
                }
                HUD.hidden = YES;
            }
        } else {
            // Log details of the failure
            [SVProgressHUD showErrorWithStatus:@"Can't get data now.Try again!"];
        }
    }];
    
}

- (IBAction)uploadLogoPressed:(id)sender {
    [self uploadLogoPresentAlert];
    
}

- (IBAction)changeLogoPressed:(id)sender {
    [self uploadLogoPresentAlert];
}

#pragma mark - LogoButtons Behaviors
- (void)showLogoButtons{
    self.uploadLogoButton.hidden    = NO;
    self.changeLogoButton.hidden    = NO;
    self.uploadLogoButton.enabled   = YES;
    self.changeLogoButton.enabled   = YES;
}

- (void)hideLogoButtons{
    self.uploadLogoButton.hidden    = YES;
    self.changeLogoButton.hidden    = YES;
    self.uploadLogoButton.enabled   = NO;
    self.changeLogoButton.enabled   = NO;
}

- (void)imageExistPresentChangeButton{
    self.uploadLogoButton.hidden    = YES;
    self.changeLogoButton.hidden    = NO;
    self.uploadLogoButton.enabled   = NO;
    self.changeLogoButton.enabled   = YES;
}

- (void)imageNotExistPresentUploadButton{
    self.uploadLogoButton.hidden    = NO;
    self.changeLogoButton.hidden    = YES;
    self.uploadLogoButton.enabled   = YES;
    self.changeLogoButton.enabled   = NO;
}


/*
 * in case of image exists, present change logo button other wise present upload logo
 */
- (void)subjectLogoButtonPrsent{
    if (self.subjectLogoImageView.image != nil){
        [self imageExistPresentChangeButton];
    }else{
        [self imageNotExistPresentUploadButton];
    }
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)uploadLogoPresentAlert{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"Upload Logo Picture" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertcontroller addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //take photo code
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:picker animated:YES completion:NULL];
        }];
        
    }]];
    
    [alertcontroller addAction:[UIAlertAction actionWithTitle:@"Upload Exit Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //uplaod exit photo code
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //your code
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:picker animated:YES completion:NULL];
        }];
    }]];
    
    [self presentViewController:alertcontroller animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegete

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((chosenImage),0.5)];
    
    //save image on parse
    [self saveChoosenImage:imageData];
    
    self.subjectLogoImageView.image = chosenImage;
    [ManageLayerViewController imageViewLayerProfilePicture:self.subjectLogoImageView Corner:100.0f];
    [self imageExistPresentChangeButton];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


/*
 */
- (void)saveChoosenImage:(NSData *)imageData{
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    PFQuery *query = [PFQuery queryWithClassName:@"Subjects"];
    [query whereKey:@"objectId" equalTo:[ManageLayerViewController getDataParsingSubjectID]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            for (PFObject *object in objects) {
                object[@"subjectLogo"] = imageFile;
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error){
                        [SVProgressHUD showSuccessWithStatus:@"Picture has been uploaded successfully"];
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"Can save this picture.Try again!"];
                    }
                }];
            }
        } else {
            // Log details of the failure
            [SVProgressHUD showErrorWithStatus:@"An error occured.Try again!"];
        }
    }];
}

- (IBAction)sendCodePressed:(id)sender {
    [self displayComposerSheet:self.codeLabel.text AndSubjectName:self.subjectLabel.text];
}

/********************************************/
//              Email                       //
/********************************************/

-(void)displayComposerSheet:(NSString*)code AndSubjectName:(NSString*)subjectName {
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:subjectName];
        
        // Set up the recipients.
        //NSArray *toRecipients = [NSArray arrayWithObjects:assigObject.assigTeacherEmail,nil];
        //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com",@"third@example.com", nil];
        //NSArray *bccRecipients = [NSArray arrayWithObjects:@"four@example.com",nil];
        //[picker setToRecipients:toRecipients];
        //[picker setCcRecipients:ccRecipients];
        //[picker setBccRecipients:bccRecipients];
        
        // Attach an image to the email.
        //    NSString *path = [[NSBundle mainBundle] pathForResource:@"ipodnano" ofType:@"png"];
        //    NSData *myData = [NSData dataWithContentsOfFile:path];
        //[picker addAttachmentData:data mimeType:@"attachment" fileName:subjectName];
        
        NSString *body = [NSString stringWithFormat:@"Subject Name: %@\nSubject Code: %@\n\nI wish you enjoy our course.\nGood Luck",subjectName,code];
        // Fill out the email body text.إ
        NSString *emailBody = body;
        [picker setMessageBody:emailBody isHTML:NO];
        
        // Present the mail composition interface.
        picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:picker animated:YES completion:NULL];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warring" message:@"Kindly enable at leat one e-mail account" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

// The mail compose view controller delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultSent:
            [SVProgressHUD showSuccessWithStatus:@"Your mail has been sent"];
            break;
        case MFMailComposeResultSaved:
            [SVProgressHUD showInfoWithStatus:@"You saved a draft of this email"];
            break;
        case MFMailComposeResultCancelled:
            [SVProgressHUD showInfoWithStatus:@"You cancelled sending this email."];
            break;
        case MFMailComposeResultFailed:
            [SVProgressHUD showErrorWithStatus:@"Mail failed:  An error occurred when trying to compose this email"];
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
