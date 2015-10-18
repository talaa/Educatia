//
//  CourseMaterialsTableViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/15/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "CourseMaterialsTableViewController.h"
#import "RNActivityView.h"
#import "UIView+RNActivityView.h"
#import "ManageLayerViewController.h"
#import <Parse/Parse.h>
#import "DataParsing.h"

@interface CourseMaterialsTableViewController () <UIDocumentPickerDelegate>
@property (strong, nonatomic) NSString *currentUserFullName;
@property (strong, nonatomic) NSString *currentUserObjectID;
@property (strong, nonatomic) NSString *currentUserName;
@property (strong, nonatomic) NSString *courseMaterialName;
@property (strong, nonatomic) NSData *documentPickerselectedData;
@end

@implementation CourseMaterialsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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

- (IBAction)addNewMaterialPressed:(id)sender {
    NSLog(@"Pressed");
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
                                                       self.courseMaterialName = courseMaterialName.text;
                                                       [self showDocumentPickerInMode:UIDocumentPickerModeOpen];
                                                       
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
            NSLog(@"NEW URL is %@", newURL);
            NSData *data = [NSData dataWithContentsOfURL:newURL];
            [self saveOnParseURL:newURL AndData:data];
            NSLog(@"error %@",error);
            NSLog(@"data %@",data);
        }];
        [url stopAccessingSecurityScopedResource];
        
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"Saved on %@", url);
//            [self saveOnParse:url];
//        });
        
    }
    //can't do import
    
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
 Saving the choisen file --> Course Materials table on Parse
 *
 */
- (void)saveOnParseURL:(NSURL*)pathURL AndData:(NSData*)data {
    //save file to upload to Course Material core
    //NSString *path = [pathURL absoluteString];
    //NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    PFFile *file = [PFFile fileWithName:[pathURL lastPathComponent] data:data];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // Handle success or failure here ...
        if (succeeded){
            PFObject *coursMaterialObject = [PFObject objectWithClassName:@"CourseMaterials"];
            coursMaterialObject[@"cmFile"]              = file;
            coursMaterialObject[@"cmName"]              = self.courseMaterialName;
            
            //save CurrentUSer data
            [self setCurrentUserData];
            coursMaterialObject[@"cmTeacherName"]       = self.currentUserFullName;
            coursMaterialObject[@"cmTeacherID"]         = self.currentUserObjectID;
            coursMaterialObject[@"cmTeacherUsername"]   = self.currentUserName;
            
            //save Subject data
            DataParsing *obj=[DataParsing getInstance];
            coursMaterialObject[@"cmSubjectName"]       = obj.subjectName;
            coursMaterialObject[@"cmSubjectID"]         = obj.subjectID;
            
            [coursMaterialObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // The object has been saved.
                    NSString *alertMessage = alertMessage = [NSString stringWithFormat:@"Successfully imported %@", [pathURL lastPathComponent]];
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"Import"
                                                          message:alertMessage
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
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
            NSLog(@"Couldnt save file because %@", error);
        }
        
        
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
    }];
    
    
}

/**
 Set current User data on local NSString
 **/
- (void)setCurrentUserData {
    self.currentUserFullName = [ManageLayerViewController getCurrentFullName];
    self.currentUserObjectID = [ManageLayerViewController getCurrentUserID];
    self.currentUserName = [ManageLayerViewController getCurrentUserName];
}
@end
