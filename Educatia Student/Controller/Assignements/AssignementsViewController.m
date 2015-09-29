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
typedef void (^CompletionHandler)(BOOL);

@interface AssignementsViewController () <ReaderViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableArray *teacherMArray;
@property (strong, nonatomic) NSMutableArray *maxScoreMArray;
@property (strong, nonatomic) NSMutableArray *deadLineMArray;
@property (strong, nonatomic) NSMutableArray *pdfPathMArray;
@property (strong, nonatomic) NSMutableArray *pdfFileDataMArray;
@property (strong, nonatomic) NSMutableArray *assignmentIDMArray;
@property (strong, nonatomic) NSString *subjectName;
@end

@implementation AssignementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _subjectName = @"Math";
    //Loading Activity
    [self.view showActivityViewWithLabel:@"Loading Assignments"];
    [self myProgressTask];
    
    [self loadAssignementObjects];
}

- (void) viewDidAppear:(BOOL)animated {
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
            _pdfPathMArray          = [[NSMutableArray alloc] init];
            _pdfFileDataMArray      = [[NSMutableArray alloc] init];
            
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                [self.assignmentIDMArray addObject:object.objectId];
                [self.teacherMArray addObject:object[@"Teacher"]];
                [self.maxScoreMArray addObject:[NSString stringWithFormat:@"%@",object[@"MaximumScore"]]];
                //convert date to string
                NSString *deadLineString = [self convertDateToString:object[@"Dead_line_date"]];
                [self.deadLineMArray addObject:deadLineString];
                
                //get pdf file
                PFFile *pdfFile = object[@"File"];
                NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pdfFile.url]];
                NSLog(@"URL is %@", pdfFile.url);
                
                //Ad to MData
                [_pdfFileDataMArray addObject:pdfData];
                // Store the Data locally as PDF File
                NSString *resourceDocPath = [[NSString alloc] initWithString:[
                                                                              [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
                                                                              stringByAppendingPathComponent:@"Educatia Student.app/"
                                                                              ]];
                NSString *fileName = [object.objectId stringByAppendingString:@".pdf"];
                NSString *filePath = [resourceDocPath stringByAppendingPathComponent:fileName];
                [pdfData writeToFile:filePath atomically:YES];
                [_pdfPathMArray addObject:filePath];
                
                //Reload Table View
                [self.assingementsTableView reloadData];
                
                //Hide Loading activity
                [self.view hideActivityView];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return (self.teacherMArray.count)?(self.teacherMArray.count):0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssignementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    //Load Objects
    cell.teacherNameLabel.text  = [self.teacherMArray objectAtIndex:indexPath.row];
    cell.maxScoreLabel.text     = [self.maxScoreMArray objectAtIndex:indexPath.row];
    cell.deadLineLabel.text     = [self.deadLineMArray objectAtIndex:indexPath.row];
    
    //Cell button
    cell.submitButton.tag = indexPath.row;
    [cell.submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //Thumbnail
    ThumbnailPDF *thumbPDF = [[ThumbnailPDF alloc] init];
    [thumbPDF startWithCompletionHandler:[_pdfFileDataMArray objectAtIndex:indexPath.row] andSize:500 completion:^(ThumbnailPDF *ThumbnailPDF, BOOL finished) {
        if (finished) {
            [ManageLayerViewController imageViewCellAssignment:cell.assignementImageView];
            cell.assignementImageView.image = [UIImage imageWithCGImage:ThumbnailPDF.myThumbnailImage];
        }
    }];
    
    //Cell Assignment Imge
    cell.assignmentButton.tag = indexPath.row;
    [cell.assignmentButton addTarget:self action:@selector(assignmentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(NSString*)convertDateToString:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSLog(@"The Date: %@", dateString);
    return dateString;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:[_pdfPathMArray objectAtIndex:indexPath.row] password:nil];
    if (document != nil)
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc]initWithReaderDocument:document];
        readerViewController.delegate = self;
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        //[self presentModalViewController:readerViewController animated:YES ];
        [self presentViewController:readerViewController animated:YES completion:nil];
    }
}
*/


#pragma mark - ReaderDocumentDelegete

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)myProgressTask {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        self.navigationController.view.rn_activityView.progress = progress;
        //usleep(50000);
    }
}

#pragma mark - CellSubmitButtonClicked

- (void)submitButtonPressed:(UIButton*)button
{
    NSIndexPath *indexPath = [self.assingementsTableView indexPathForCell:(UITableViewCell *)
                              [[button superview] superview]];
    AssignementTableViewCell *cell = [self.assingementsTableView cellForRowAtIndexPath:indexPath];
    //NSLog(@"The row id is %ld",  (long)button.tag);
    
    //ActionView take photo or upload exist one
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Submit your file"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Take a photo", @"Upload a file",nil];
    //Actionsheet for IPad
    [actionSheet showFromRect:cell.submitButton.frame inView:cell animated:YES];
}

#pragma mark - CellAssignmentButtonClicked

- (void)assignmentButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.assingementsTableView indexPathForCell:(AssignementTableViewCell *)[[sender superview] superview]];
    //NSLog(@"The row id is %ld",  (long)indexPath.row);
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:[_pdfPathMArray objectAtIndex:indexPath.row] password:nil];
    if (document != nil)
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc]initWithReaderDocument:document];
        readerViewController.delegate = self;
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:readerViewController animated:YES completion:nil];
    }else {
        TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:[UIImage imageWithData:[_pdfFileDataMArray objectAtIndex:indexPath.row]]];
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
    NSLog(@"Button Index %ld", (long)buttonIndex);
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
    NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((chosenImage),1.0)];
    //NSLog(@"Image size is %lu", (unsigned long)imageData.length);
    if (imageData.length > 500000){
        //self.picProfileImageView.image = [UIImage imageNamed:@"Image_AddProfilPic"];
        [[[UIAlertView alloc] initWithTitle:@"EducationStudent" message:@"Picture you have choosen is greater than 400K!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }else {
        //Submit student file
        [self uploadsubmissionFile];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// Upload Submission file and fill Submission class data
- (void)uploadsubmissionFile {
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
    submissionObject[@"assignmentID"] = [_assignmentIDMArray objectAtIndex:1];
    
    [submissionObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        } else {
            // There was a problem, check error.description
        }
    }];

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

@end
