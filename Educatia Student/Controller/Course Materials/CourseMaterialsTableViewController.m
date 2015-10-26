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
#import "CourseMaterialTableViewCell.h"
#import "ReaderViewController.h"
#import "ThumbnailPDF.h"
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"

@interface CourseMaterialsTableViewController () <UIDocumentPickerDelegate,ReaderViewControllerDelegate,UIViewControllerTransitioningDelegate>
{
    BOOL *isCurrentUserisTeacher;
}
@property (strong, nonatomic) NSString *currentUserFullName;
@property (strong, nonatomic) NSString *currentUserObjectID;
@property (strong, nonatomic) NSString *currentUserName;
@property (strong, nonatomic) NSString *courseMaterialName;
@property (strong, nonatomic) NSData *documentPickerselectedData;

@property (strong, nonatomic) NSMutableArray *materislFileMArray;
@property (strong, nonatomic) NSMutableArray *materialFilePathMArray;
@property (strong, nonatomic) NSMutableArray *materialNameMArray;
@property (strong, nonatomic) NSMutableArray *materialTeacherMArray;
@property (strong, nonatomic) NSMutableArray *materialDataFileMArray;
@end

@implementation CourseMaterialsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load Materials Objects
    
    
    [self loadMaterialsObjects];
    
    if ([ManageLayerViewController isCurrentUserisTeacher] == YES){
        //Is a Teacher
        self.addNewMaterilView.hidden       = NO;
        self.addNewMaterialButton.hidden    = NO;
    }else{
        //Is a Student
        self.addNewMaterilView.hidden       = YES;
        self.addNewMaterialButton.hidden    = YES;
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [_materialFilePathMArray count]? 1: 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_materialFilePathMArray count]? [_materialFilePathMArray count]:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.materialName.text = [_materialNameMArray objectAtIndex:indexPath.row];
    cell.TeacherName.text  = [_materialTeacherMArray objectAtIndex:indexPath.row];
    
    //materialButton action
    cell.materialButton.tag = indexPath.row;
    [cell.materialButton addTarget:self action:@selector(materialButtonViewPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_materialFilePathMArray count] > 0) {
        //Thumbnail
        ThumbnailPDF *thumbPDF = [[ThumbnailPDF alloc] init];
        [thumbPDF startWithCompletionHandler:[_materialDataFileMArray objectAtIndex:indexPath.row] andSize:500 completion:^(ThumbnailPDF *ThumbnailPDF, BOOL finished) {
            if (finished) {
                //             [ManageLayerViewController imageViewCellAssignment:cell.assignementImageView];
                cell.materialImageView.image = [UIImage imageWithCGImage:ThumbnailPDF.myThumbnailImage];
            }
        }];

    }
    
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

/*
 load course materials objects
 */
- (void)loadMaterialsObjects {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       
        PFQuery *query = [PFQuery queryWithClassName:@"CourseMaterials"];
        [query whereKey:@"cmSubjectName" equalTo:[ManageLayerViewController getDataParsingSubjectName]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                //init NSMutableArray
                _materialNameMArray     = [[NSMutableArray alloc] init];
                _materialTeacherMArray  = [[NSMutableArray alloc] init];
                _materislFileMArray     = [[NSMutableArray alloc] init];
                _materialDataFileMArray = [[NSMutableArray alloc] init];
                _materialFilePathMArray = [[NSMutableArray alloc] init];
                
                // Do something with the found objects
                for (PFObject *object in objects) {
                    //NSLog(@"%@", object.objectId);
                    [_materialNameMArray addObject:object[@"cmName"]];
                    [_materialTeacherMArray addObject:object[@"cmTeacherName"]];
                    
                    //get pdf file
                    PFFile *cmFile = object[@"cmFile"];
                    NSData *cmFileData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:cmFile.url]];
                    
                    //Ad to MData
                    [_materialDataFileMArray addObject:cmFileData];
                    
                    //save file locally
                    if ( cmFileData )
                    {
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[cmFile.url lastPathComponent]];
                        [cmFileData writeToFile:filePath atomically:YES];
                        [_materialFilePathMArray addObject:filePath];
                        NSLog(@"Count is %ld", (unsigned long)[_materialFilePathMArray count]);
                    }
                }
                
            }else {
                // [self activityStopLoading];
            }
        }];
        /////////////////////////////
        // now send the result back to the main thread so we can do
        // UIKit stuff
        dispatch_async(dispatch_get_main_queue(), ^{
            // set the images on your UIImageViews here...
            [self.tableView reloadData];
        });
    });
    //[self activityLoadingwithLabel];
    
    
}


- (IBAction)addNewMaterialPressed:(id)sender {
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
            NSData *data = [NSData dataWithContentsOfURL:newURL];
            [self saveOnParseURL:newURL AndData:data];
        }];
        [url stopAccessingSecurityScopedResource];
    }else{
        //can't do import
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"Error" message:@"Can't import the file now, please try again!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertcontroller addAction:okAction];
        [self presentViewController:alertcontroller animated:YES completion:nil];
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
            coursMaterialObject[@"cmSubjectName"]       = [ManageLayerViewController getDataParsingSubjectName];
            coursMaterialObject[@"cmSubjectID"]         = [ManageLayerViewController getDataParsingSubjectID];
            
            [coursMaterialObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
                    [self loadMaterialsObjects];
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
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Error"
                                                  message:@"Sorry, can't import this file now.Please try it again."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
    }];
    
    
}

/**
 Set current User data on local NSString
 **/
- (void)setCurrentUserData {
    self.currentUserFullName    = [ManageLayerViewController getDataParsingCurrentName];
    self.currentUserObjectID    = [ManageLayerViewController getDataParsingCurrentuserID];
    self.currentUserName        = [ManageLayerViewController getDataParsingCurrentusername];
}


#pragma mark - CellAssignmentButtonClicked

- (void)materialButtonViewPressed:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(CourseMaterialTableViewCell *)[[sender superview] superview]];
    NSLog(@"The row id is %ld",  (long)indexPath.row);
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:[_materialFilePathMArray objectAtIndex:indexPath.row] password:nil];
    if (document != nil)
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc]initWithReaderDocument:document];
        readerViewController.delegate = self;
        readerViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        readerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:readerViewController animated:YES completion:nil];
    }else {
        TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:[UIImage imageWithData:[_materialDataFileMArray objectAtIndex:indexPath.row]]];
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



@end
