//
//  AssignmentsTableViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/21/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "AssignmentsTableViewController.h"
#import "ManageLayerViewController.h"
#import "AssignementTableViewCell.h"
#import "HSDatePickerViewController.h"
#import "ReaderViewController.h"
#import "ThumbnailPDF.h"
#import "AssignmentObject.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

@interface AssignmentsTableViewController () <UIDocumentPickerDelegate,HSDatePickerViewControllerDelegate,ReaderViewControllerDelegate,MBProgressHUDDelegate>
{
    NSMutableArray      *assignmentsMArray;
    NSOperationQueue    *operationQueue;
    NSOperationQueue    *mainQueue;
    bool                isLoadingObjectsFinished;
    MBProgressHUD       *HUD;
}

@property (strong, nonatomic) NSData *documentPickerselectedData;

@property (strong, nonatomic) NSDate *deadLineDate;
@property (strong, nonatomic) NSString *deadLineString;
@property (strong, nonatomic) NSString *assignmentName;
@property (strong, nonatomic) NSString *assignmentMaxScore;

@end

@implementation AssignmentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLoadingObjectsFinished = FALSE;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Loading...";
    
    operationQueue      = [[NSOperationQueue alloc] init];
    mainQueue           = [NSOperationQueue mainQueue];
    assignmentsMArray   = [NSMutableArray new];
    
    if ([ManageLayerViewController getDataParsingIsCurrentTeacher]) {
        self.addNewAssignmentView.hidden = NO;
    }else {
        self.addNewAssignmentView.hidden = YES;
    }
    
    [self loadAssignmentsObjects];
}

- (void)viewDidAppear:(BOOL)animated{
    if (isLoadingObjectsFinished){
        HUD.hidden = YES;
    }else{
        HUD.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    HUD.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [assignmentsMArray count]? [assignmentsMArray count]:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssignementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssignmentCell" forIndexPath:indexPath];
    
    // Configure the cell...
    AssignmentObject *assigObject = [assignmentsMArray objectAtIndex:indexPath.row];
    cell.assignmentNameLabel.text   = assigObject.assigName;
    cell.teacherNameLabel.text      = assigObject.assigTeacherName;
    cell.deadLineLabel.text         = [self convertDateToString:assigObject.assigDeadLine];
    cell.maxScoreLabel.text         = assigObject.assigMaxScore;
    
    // submit button
    if ([ManageLayerViewController getDataParsingIsCurrentTeacher]){
        cell.submitSolutionButton.hidden = YES;
    }else{
        cell.submitSolutionButton.hidden = NO;
        cell.submitSolutionButton.tag    = indexPath.row;
        [cell.submitSolutionButton addTarget:self action:@selector(SubmitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    //Cell Assignment View
    cell.assignmentViewButton.tag = indexPath.row;
    [cell.assignmentViewButton addTarget:self action:@selector(assignmentViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        //Thumbnail
        ThumbnailPDF *thumbPDF = [[ThumbnailPDF alloc] init];
        [thumbPDF startWithCompletionHandler:assigObject.assigFile andSize:500 completion:^(ThumbnailPDF *ThumbnailPDF, BOOL finished) {
            if (finished) {
                cell.assignementImageView.image = [UIImage imageWithCGImage:ThumbnailPDF.myThumbnailImage];
            }
        }];
    });
    
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */
- (IBAction)addNewAssignmentPressed:(id)sender {
    [self presentAlretController];
}

/*
 AlertController to add new material
 */
- (void)presentAlretController {
    UIAlertController * alertController =   [UIAlertController alertControllerWithTitle:@"Add New Assignment" message:@"Enter New Assignment Data\n1- Type assignment's name.\n2- Type assignment's maxmuim score.\n3- Select dead line date.\n4- Pick up assignment's file."preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *deadLine = [UIAlertAction actionWithTitle:[self deadLineButtonTitle] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        UITextField *assignmentNameTextField        = alertController.textFields.firstObject;
        _assignmentName                             = assignmentNameTextField.text;
        
        UITextField *assignmentMaxScoreTextfield    = alertController.textFields.lastObject;
        _assignmentMaxScore                         = assignmentMaxScoreTextfield.text;
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        HSDatePickerViewController *hsdpvc = [HSDatePickerViewController new];
        hsdpvc.delegate = self;
        if (self.deadLineDate) {
            hsdpvc.date = self.deadLineDate;
        }
        [self presentViewController:hsdpvc animated:YES completion:nil];
    }];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Add File" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //Do Some action here ---> OK
        UITextField *assignmentNameTextfield        = alertController.textFields.firstObject;
        self.assignmentName                         = assignmentNameTextfield.text;
        
        UITextField *assignmentMaxScoreTextField    = alertController.textFields.lastObject;
        self.assignmentMaxScore                     = assignmentMaxScoreTextField.text;
        
        if (self.assignmentName.length > 1 && self.assignmentMaxScore.length > 1 && self.deadLineDate) {
            //start ActivityIndicator
            [SVProgressHUD showWithStatus:@"Loading..."];
            [self showDocumentPickerInMode:UIDocumentPickerModeOpen];
            [SVProgressHUD dismiss];
            
        }else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Assignment name, max score and deadline must be typed first correnctly." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        //flush properities
        self.assignmentName     = nil;
        self.assignmentMaxScore = nil;
        self.deadLineDate       = nil;
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:deadLine];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField* textField) {
        textField.placeholder   = @"Assignment Name";
        textField.keyboardType  = UIKeyboardTypeDefault;
        textField.text          = [self assignmentNameTextFieldText];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField* textField) {
        textField.placeholder = @"Assignment Maxmuim Score";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.text          = [self assignmentMaxScoreTextFieldText];
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark <DocumentPickerDelegate>

- (void)showDocumentPickerInMode:(UIDocumentPickerMode)mode {
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:[self allowedUTIs] inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

/*
 *
 * Handle Incoming File
 *
 */
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
            NSData *data = [NSData dataWithContentsOfURL:newURL];
            [self saveOnParseURL:newURL AndData:data];
        }];
        [url stopAccessingSecurityScopedResource];
    }else{
        //can't do import
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Can't import the file now, please try again!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        [SVProgressHUD dismiss];
    }
}

/*
 *
 * Cancelled
 *
 */
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    NSLog(@"Cancelled");
}


- (NSArray*)allowedUTIs{
    return @[@"kUTTypeContent",@"kUTTypeItem",@"public.audiovisual-content",@"public.movie",@"public.audiovisual-content",@"public.video",@"public.audio",@"public.text",@"public.data",@"public.zip-archive",@"com.pkware.zip-archive",@"public.composite-content",@"public.text"];
}


/*
 *
 ********** Saving the choisen file --> Course Materials table on Parse *******************
 *
 */
- (void)saveOnParseURL:(NSURL*)pathURL AndData:(NSData*)data {
    //save file to upload to Course Material core
    PFFile *file = [PFFile fileWithName:[pathURL lastPathComponent] data:data];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // Handle success or failure here ...
        if (succeeded){
            PFObject *assignmentObject = [PFObject objectWithClassName:@"Assignement"];
            assignmentObject[@"assignmentFile"]     = file;
            assignmentObject[@"assignmentName"]     = self.assignmentName;
            assignmentObject[@"assignmentMaxScore"] = self.assignmentMaxScore;
            assignmentObject[@"assignmentDeadLine"] = self.deadLineDate;
            
            //save CurrentUSer Teacher data
            assignmentObject[@"teacherID"]          = [ManageLayerViewController getDataParsingCurrentuserID];
            assignmentObject[@"teacherUserName"]    = [ManageLayerViewController getDataParsingCurrentusername];
            assignmentObject[@"teacherName"]        = [ManageLayerViewController getDataParsingCurrentName];
            assignmentObject[@"teacherEmail"]       = [ManageLayerViewController getDataParsingCurrentUserEmail];
            //save Subject data
            assignmentObject[@"subjectID"]          = [ManageLayerViewController getDataParsingSubjectID];
            assignmentObject[@"subjectName"]        = [ManageLayerViewController getDataParsingSubjectName];
            
            [assignmentObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // The object has been saved.
                    NSString *alertMessage = alertMessage = [NSString stringWithFormat:@"Successfully imported %@", [pathURL lastPathComponent]];
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"Import"
                                                          message:alertMessage
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    // refresh table view to present latest assignments
                    [SVProgressHUD dismiss];
                    [self loadAssignmentsObjects];
                    [self.tableView reloadData];
                } else {
                    // There was a problem, check error.description
                    // The object has been saved.
                    NSLog(@"Error is %@", error);
                    NSString *alertMessage = alertMessage = [NSString stringWithFormat:@"Ops,UnSuccessfully imported, %@", [pathURL lastPathComponent]];
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"Import Error"
                                                          message:alertMessage
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [SVProgressHUD dismiss];
                }
            }];
            
        } else {
            [SVProgressHUD dismiss];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Sorry, can't import this file now.Please try it again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        [SVProgressHUD showProgress:percentDone status:@"uploading file ...."];
    }];
}


#pragma mark - HSDatePickerViewControllerDelegate
- (void)hsDatePickerPickedDate:(NSDate *)date {
    NSLog(@"Date picked %@", date);
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    self.deadLineString = [dateFormater stringFromDate:date];
    self.deadLineDate = date;
}

//optional
- (void)hsDatePickerDidDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    NSLog(@"Picker did dismiss with %lu", (unsigned long)method);
    [self presentAlretController];
}

//optional
- (void)hsDatePickerWillDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    NSLog(@"Picker will dismiss with %lu", (unsigned long)method);
}

/*
 *
 Set SelectDeadLineButton title on UIAlertControl
 *
 */
- (NSString*)deadLineButtonTitle {
    if (self.deadLineString.length == 0){
        return @"Select DeadLine Date";
    }else{
        return self.deadLineString;
    }
}

- (NSString*)assignmentNameTextFieldText {
    if (![self.assignmentName isEqualToString:@""] && self.assignmentName !=nil){
        return self.assignmentName;
    }else{
        return @"";
    }
}

- (NSString*)assignmentMaxScoreTextFieldText {
    if (![self.assignmentMaxScore isEqualToString:@""] && self.assignmentMaxScore != nil) {
        return self.assignmentMaxScore;
    }else {
        return @"";
    }
}

/*
 *
 ******** Load Assignment Objects *************
 *
 */
- (void)loadAssignmentsObjects {
    PFQuery *query = [PFQuery queryWithClassName:@"Assignement"];
    NSString *subjID = [ManageLayerViewController getDataParsingSubjectID];
    [query whereKey:@"subjectID" equalTo:subjID];
    if ([ManageLayerViewController isCurrentUserisTeacher]){
        [query whereKey:@"teacherID" equalTo:[ManageLayerViewController getCurrentUserID]];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [operationQueue addOperationWithBlock:^{
                [assignmentsMArray removeAllObjects];
                // Perform long-running tasks without blocking main thread
                for (PFObject *object in objects) {
                    [assignmentsMArray addObject:[[AssignmentObject alloc] initWithObject:object]];
                }
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Main thread work (UI usually)
                    [self.tableView reloadData];
                    isLoadingObjectsFinished = TRUE;
                    HUD.hidden = YES;
                }];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Unable to get course assignment now.Try again!"];
        }
    }];
}

/*
 *
 ********* Convert from NSDate to NSString *********************
 *
 */
- (NSString*)convertDateToString:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    //NSLog(@"The Date: %@", dateString);
    return dateString;
}


#pragma mark - CellSubmitButtonClicked
- (void)SubmitButtonPressed:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(AssignementTableViewCell *)[[sender superview] superview]];
    AssignmentObject *assigObject = [assignmentsMArray objectAtIndex:indexPath.row];
    [self displayComposerSheet:assigObject];
}


-(void)displayComposerSheet:(AssignmentObject*)assigObject {
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:assigObject.assigName];
        
        // Set up the recipients.
        NSArray *toRecipients = [NSArray arrayWithObjects:assigObject.assigTeacherEmail,nil];
        //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com",@"third@example.com", nil];
        //NSArray *bccRecipients = [NSArray arrayWithObjects:@"four@example.com",nil];
        [picker setToRecipients:toRecipients];
        //[picker setCcRecipients:ccRecipients];
        //[picker setBccRecipients:bccRecipients];
        
        // Attach an image to the email.
        //    NSString *path = [[NSBundle mainBundle] pathForResource:@"ipodnano" ofType:@"png"];
        //    NSData *myData = [NSData dataWithContentsOfFile:path];
         //  [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"ipodnano"];
        
        NSString *body = [NSString stringWithFormat:@"Student Name: %@ \nStudent ID: %@ \n\nSubject Name: %@ \nSubject ID: %@\n\n Assignment Name: %@",[ManageLayerViewController getDataParsingCurrentName],[ManageLayerViewController getDataParsingCurrentuserID],assigObject.subjectName,assigObject.subjectID,assigObject.assigName];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - CellAssignmentButtonClicked

- (void)assignmentViewButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(AssignementTableViewCell *)[[sender superview] superview]];
    AssignmentObject *assigObject = [assignmentsMArray objectAtIndex:indexPath.row];
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:assigObject.assigFilePath password:nil];
    if (document != nil)
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc]initWithReaderDocument:document];
        readerViewController.delegate = self;
        readerViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        readerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:readerViewController animated:YES completion:nil];
    }else {
        TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:[UIImage imageWithData:assigObject.assigFile]];
        // Don't forget to set ourselves as the transition delegate
        viewController.transitioningDelegate = self;
        viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

/*
 *
 Dismiss Document Reader
 *
 */
- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
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


@end
