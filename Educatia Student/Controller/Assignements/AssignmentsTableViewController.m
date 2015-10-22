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
#import "RNActivityView.h"
#import "UIView+RNActivityView.h"
#import "HSDatePickerViewController.h"

@interface AssignmentsTableViewController () <UIDocumentPickerDelegate,HSDatePickerViewControllerDelegate>

@property (strong, nonatomic) NSData *documentPickerselectedData;

@property (strong, nonatomic) NSMutableArray *assigIDMArray;
@property (strong, nonatomic) NSMutableArray *assigNameMArray;
@property (strong, nonatomic) NSMutableArray *assigTeacherMArray;
@property (strong, nonatomic) NSMutableArray *assignMAXScoreMArray;
@property (strong, nonatomic) NSMutableArray *assigDeadLineMArray;

@property (strong, nonatomic) NSDate *deadLineDate;
@property (strong, nonatomic) NSString *deadLineString;
@property (strong, nonatomic) NSString *assignmentName;
@property (strong, nonatomic) NSNumber *assignmentMaxScore;

@end

@implementation AssignmentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // if current is a Teacher, then present ADDNEWASSIGNMENT uiview
    if ([ManageLayerViewController getDataParsingIsCurrentTeacher]) {
        self.addNewAssignmentView.hidden = NO;
    }else {
        self.addNewAssignmentView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [_assigIDMArray count]? 1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_assigIDMArray count]? [_assigIDMArray count]:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssignementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssignmentCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
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

/*
 #pragma mark - Navigation
 
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
    UIAlertController * alertController =   [UIAlertController alertControllerWithTitle:@"Add New Assignment" message:@"Enter New Assignment Data\n1- Type assignment's name.\n2- Type assignment's maxmuim score.\n3- Select dead line date.\n4- Pick up assignment's file."preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *deadLine = [UIAlertAction actionWithTitle:[self deadLineButtonTitle] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        UITextField *assignmentTextField     = alertController.textFields.firstObject;
        _assignmentName = assignmentTextField.text;
        self.assignmentMaxScore = alertController.textFields.lastObject;
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
        self.assignmentName     = alertController.textFields.firstObject;
        self.assignmentMaxScore = alertController.textFields.lastObject;
        if (self.assignmentName.length > 0 && self.assignmentMaxScore > 0 && self.deadLineDate != NULL) {
            //start ActivityIndicator
            [self activityLoadingwithLabel];
            // self.courseMaterialName = courseMaterialName.text;
            [self showDocumentPickerInMode:UIDocumentPickerModeOpen];
            
        }else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Assignment name, max score and deadline must be typed first correnctly." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
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
        //Successful import
        BOOL startAccessingWorked = [url startAccessingSecurityScopedResource];
        NSURL *ubiquityURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        NSLog(@"ubiquityURL %@",ubiquityURL);
        NSLog(@"start %d",startAccessingWorked);
        
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
            NSData *data = [NSData dataWithContentsOfURL:newURL];
            [self saveOnParseURL:newURL AndData:data];
        }];
        [url stopAccessingSecurityScopedResource];
    }else{
        //can't do import
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't import the file now, please try again!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
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
            PFObject *assignmentObject = [PFObject objectWithClassName:@"Assignments"];
            assignmentObject[@"assignmentFile"]              = file;
            
            //save CurrentUSer data
            
            //save Subject data
            
            
            [assignmentObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // The object has been saved.
                    [self activityStopLoading];
                    NSString *alertMessage = alertMessage = [NSString stringWithFormat:@"Successfully imported %@", [pathURL lastPathComponent]];
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"Import"
                                                          message:alertMessage
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    // refresh table view to present latest assignments
                    //[self loadMaterialsObjects];
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
                    [self activityStopLoading];
                }
            }];
            
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, can't import this file now.Please try it again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
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
    NSLog(@"Picker did dismiss with %lu", method);
    [self presentAlretController];
}

//optional
- (void)hsDatePickerWillDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    NSLog(@"Picker will dismiss with %lu", method);
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
@end
