//
//  AssignementsViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//
#import "RNActivityView.h"
#import "UIView+RNActivityView.h"
#import "AssignementsViewController.h"
#import "AssignementTableViewCell.h"
#import <Parse/Parse.h>
#import "ManageLayerViewController.h"
#import "ThumbnailPDF.h"
#import "ReaderViewController.h"
#import "NHNetworkTime.h"

typedef void (^CompletionHandler)(BOOL);

@interface AssignementsViewController () <ReaderViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,UIDocumentPickerDelegate>
{
    NSDate *networkDate;
    BOOL isCurrentTeacher;
}

@property (strong, nonatomic) NSMutableArray *teacherMArray;
@property (strong, nonatomic) NSMutableArray *maxScoreMArray;
@property (strong, nonatomic) NSMutableArray *deadLineMArray;
@property (strong, nonatomic) NSMutableArray *assignmentFileLocalPathMArray;
@property (strong, nonatomic) NSMutableArray *assignmentFileDataMArray;
@property (strong, nonatomic) NSMutableArray *assignmentIDMArray;
@property (strong, nonatomic) NSString *subjectName;
@property (strong, nonatomic) NSString *assignmentID;

@end

@implementation AssignementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Loading Activity
    [self.view showActivityViewWithLabel:@"Loading Assignments"];
    
    [self loadAssignementObjects];
    
    //Is current user a teacher?
    isCurrentTeacher = [ManageLayerViewController isCurrentUserisTeacher];
    if (isCurrentTeacher){
        self.addNewAssignmentView.hidden = NO;
    }else {
        self.addNewAssignmentView.hidden = YES;
    }
}

- (void) viewDidAppear:(BOOL)animated {
    //networkDate = [NSDate networkDate];
    //[self updateDate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAssignementObjects {
    PFQuery *query = [PFQuery queryWithClassName:@"Assignement"];
    [query whereKey:@"Subject" equalTo:@"Math"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            //init NSMutableArray
            _assignmentIDMArray     = [[NSMutableArray alloc] init];
            _teacherMArray          = [[NSMutableArray alloc] init];
            _maxScoreMArray         = [[NSMutableArray alloc] init];
            _deadLineMArray         = [[NSMutableArray alloc] init];
            _assignmentFileLocalPathMArray          = [[NSMutableArray alloc] init];
            _assignmentFileDataMArray      = [[NSMutableArray alloc] init];
            
            // The find succeeded.
            //NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                //NSLog(@"%@", object.objectId);
                [self.assignmentIDMArray addObject:object.objectId];
                [self.teacherMArray addObject:object[@"Teacher"]];
                [self.maxScoreMArray addObject:[NSString stringWithFormat:@"%@",object[@"MaximumScore"]]];
                //convert date to string
                NSString *deadLineString = [self convertDateToString:object[@"Dead_line_date"]];
                [self.deadLineMArray addObject:deadLineString];
                
                //get pdf file
                PFFile *pdfFile = object[@"File"];
                NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pdfFile.url]];
                //NSLog(@"URL is %@", pdfFile.url);
                
                //Ad to MData
                [_assignmentFileDataMArray addObject:pdfData];
                // Store the Data locally as PDF File
                NSString *resourceDocPath = [[NSString alloc] initWithString:[
                                                                              [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
                                                                              stringByAppendingPathComponent:@"Educatia Student.app/"
                                                                              ]];
                NSString *fileName = [object.objectId stringByAppendingString:@".pdf"];
                NSString *filePath = [resourceDocPath stringByAppendingPathComponent:fileName];
                [pdfData writeToFile:filePath atomically:YES];
                [_assignmentFileLocalPathMArray addObject:filePath];
                
                //Reload Table View
                [self.assingementsTableView reloadData];
                
                //Hide Loading activity
                [self.view hideActivityView];
            }
        } else {
            // Log details of the failure
            //NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [_assignmentIDMArray count]? 1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_assignmentIDMArray count]? [_assignmentIDMArray count]:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssignementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    //Load Objects
    cell.teacherNameLabel.text  = [self.teacherMArray objectAtIndex:indexPath.row];
    cell.maxScoreLabel.text     = [self.maxScoreMArray objectAtIndex:indexPath.row];
    cell.deadLineLabel.text     = [self.deadLineMArray objectAtIndex:indexPath.row];
    
        //[cell.submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
//    //Thumbnail
//    ThumbnailPDF *thumbPDF = [[ThumbnailPDF alloc] init];
//    [thumbPDF startWithCompletionHandler:[_assignmentFileDataMArray objectAtIndex:indexPath.row] andSize:500 completion:^(ThumbnailPDF *ThumbnailPDF, BOOL finished) {
//        if (finished) {
//            [ManageLayerViewController imageViewCellAssignment:cell.assignementImageView];
//            cell.assignementImageView.image = [UIImage imageWithCGImage:ThumbnailPDF.myThumbnailImage];
//        }
//    }];
    
    //Cell Assignment Imge
//    cell.assignmentButton.tag = indexPath.row;
//    [cell.assignmentButton addTarget:self action:@selector(assignmentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(NSString*)convertDateToString:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    //NSLog(@"The Date: %@", dateString);
    return dateString;
}

// To get selected assignemnt object ID
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _assignmentID = [_assignmentIDMArray objectAtIndex:indexPath.row];
}



#pragma mark - ReaderDocumentDelegete

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - CellSubmitButtonClicked

- (void)submitButtonPressed:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    //NSLog(@"current Row=%ld",(long)senderButton.tag);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:senderButton.tag inSection:0];
    AssignementTableViewCell *cell = [self.assingementsTableView cellForRowAtIndexPath:indexPath];
    
    //Get AssignmentID by snderButton.tag
    _assignmentID = [_assignmentIDMArray objectAtIndex:senderButton.tag];
    
    //ActionView take photo or upload exist one
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Submit your file"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Take a photo", @"Upload a file",nil];
    //Actionsheet for IPad
    [actionSheet showFromRect:cell.submitSolutionButton.frame inView:cell animated:YES];
}

#pragma mark - CellAssignmentButtonClicked

- (void)assignmentButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.assingementsTableView indexPathForCell:(AssignementTableViewCell *)[[sender superview] superview]];
    //NSLog(@"The row id is %ld",  (long)indexPath.row);
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:[_assignmentFileLocalPathMArray objectAtIndex:indexPath.row] password:nil];
    if (document != nil)
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc]initWithReaderDocument:document];
        readerViewController.delegate = self;
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:readerViewController animated:YES completion:nil];
    }else {
        TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:[UIImage imageWithData:[_assignmentFileDataMArray objectAtIndex:indexPath.row]]];
        // Don't forget to set ourselves as the transition delegate
        viewController.transitioningDelegate = self;
        viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

#pragma mark - UIActionsheet delegete

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"Button Index %ld", (long)buttonIndex);
    if (buttonIndex == 0){ // Cancel button
        // No thing to do
    }
    
    if (buttonIndex == 1) { // Take a Photo
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
    if (buttonIndex == 2) { // Upload a File
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //your code
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:picker animated:YES completion:NULL];
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegete

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //Check if picture size is greater than 400K
    NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((chosenImage),0.5)];
    //NSLog(@"Image size is %lu", (unsigned long)imageData.length);
    if (imageData.length > 5000000000){
        //self.picProfileImageView.image = [UIImage imageNamed:@"Image_AddProfilPic"];
        [[[UIAlertView alloc] initWithTitle:@"EducationStudent" message:@"Picture you have choosen is greater than 400K!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }else {
        //Submit student file
        [self uploadsubmissionFile:imageData];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// Upload Submission file and fill Submission class data
- (void)uploadsubmissionFile:(NSData*)imageData {
    //NSActivity start
    [self.view showActivityViewWithLabel:@"Uploading Your File...."];
    
    PFUser *user = [PFUser currentUser];
    NSString *firstName = user[@"FirstName"];
    NSString *lastName  = user[@"LastName"];
    
    //Submission class object
    PFObject *submissionObject = [PFObject objectWithClassName:@"Submission"];
    
    //Save student data
    submissionObject[@"studentID"] = user.objectId;
    submissionObject[@"studentUserName"] = user.username;
    submissionObject[@"studentName"] = [[firstName stringByAppendingString:@" "] stringByAppendingString:lastName];
    
    //save Assignment data
    submissionObject[@"assignmentID"] = _assignmentID;
    
    //save subject name
    submissionObject[@"subjectName"] = _subjectName;
    
    //save assignment file
    PFFile *imageFile = [PFFile fileWithName:[[user.objectId stringByAppendingString:_assignmentID] stringByAppendingString:@"_image.png"] data:imageData];
    submissionObject[@"submissionFile"] = imageFile;
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            //in case of save submission photo successfully, then save submission object
            NSLog(@"Your photo upladed");
            [self.view hideActivityView];
            [submissionObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // The object has been saved.
                    NSLog(@"Successed........");
                    [self.view showActivityViewWithLabel:@"Completed" image:[UIImage imageNamed:@"37x-Checkmark.png"]];
                    [self.view hideActivityViewWithAfterDelay:2];
                } else {
                    // There was a problem, check error.description
                    //NSLog(@"Failed");
                    [[[UIAlertView alloc] initWithTitle:@"Education Student" message:@"Something has gone error, try again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                }
            }];
        }else {
            //NSLog(@"Failed");
            [[[UIAlertView alloc] initWithTitle:@"Education Student" message:@"Something has gone error, try again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
        // Handle success or failure here ...
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        // This just increases the progress indicator in a loop
    }];
    
    

}

#pragma mark - UpdateDate
- (void)updateDate {
    if([NHNetworkClock sharedNetworkClock].isSynchronized) {
        NSLog(@"Time is SYNCHRONIZED");
        NSLog(@"Network is:  %@",networkDate);
        NSLog(@"Local is:  %@",[NSDate date]);
    }
    else {
        NSLog(@"Time is NOT synchronized");
    }
}
/*
#pragma mark - UIViewControllerTransitioningDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.imageButton.imageView];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.imageButton.imageView];
    }
    return nil;
}
*/
/*
  Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


// #pragma mark - Navigation
 /*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
}
*/

- (IBAction)addNewAssignmentPressed:(id)sender {
    [self presentAlretController];
}

/*
 AlertController to add new material
 */
- (void)presentAlretController {
    UIAlertController * alertController=   [UIAlertController
                                            alertControllerWithTitle:@"Add New Material"
                                            message:@"Enter New Material Name"
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Add File" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Do Some action here ---> OK
                                                   UITextField *courseMaterialName = alertController.textFields.firstObject;
                                                   
                                                   //start ActivityIndicator
                                                   [self activityLoadingwithLabel];
                                                   
                                                   if (courseMaterialName.text.length > 4) {
                                                       //self.courseMaterialName = courseMaterialName.text;
                                                       //[self showDocumentPickerInMode:UIDocumentPickerModeOpen];
                                                       
                                                   }else {
                                                       [self activityError];
                                                   }
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action) {
                                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField* textField) {
        textField.placeholder = @"Material Name";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
 ShowActivity Methos
 */

- (void)activityCompletedSuccessfully {
    [self.view showActivityViewWithLabel:@"Subject has been added" image:[UIImage imageNamed:@"37x-Checkmark.png"]];
    [self.view hideActivityViewWithAfterDelay:2];
}

- (void)activityError {
    [self.view showActivityViewWithLabel:@"Error,Try again!" image:[UIImage imageNamed:@"32x-Closemark.png"]];
    [self.view hideActivityViewWithAfterDelay:2];
}

- (void)activityLoadingwithLabel {
    [self.view showActivityViewWithLabel:@"Loading...."];
}

- (void)activityStopLoading {
    [self.view hideActivityView];
}

@end
