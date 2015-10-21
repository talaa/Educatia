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

@interface AssignmentsTableViewController () <UIDocumentPickerDelegate>
@property (strong, nonatomic) NSData *documentPickerselectedData;
@property (strong, nonatomic) NSMutableArray *assigIDMArray;
@property (strong, nonatomic) NSMutableArray *assigNameMArray;
@property (strong, nonatomic) NSMutableArray *assigTeacherMArray;
@property (strong, nonatomic) NSMutableArray *assignMAXScoreMArray;
@property (strong, nonatomic) NSMutableArray *assigDeadLineMArray;
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
    UIAlertController * alertController=   [UIAlertController
                                            alertControllerWithTitle:@"Add New Assignment"
                                            message:@"Enter New Assignment Name"
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Add File" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Do Some action here ---> OK
                                                   UITextField *courseMaterialName = alertController.textFields.firstObject;
                                                   
                                                   //start ActivityIndicator
                                                   //[self activityLoadingwithLabel];
                                                   
                                                   if (courseMaterialName.text.length > 4) {
                                                      // self.courseMaterialName = courseMaterialName.text;
                                                       [self showDocumentPickerInMode:UIDocumentPickerModeOpen];
                                                       
                                                   }else {
                                                      // [self activityError];
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
            //[self saveOnParseURL:newURL AndData:data];
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

@end
