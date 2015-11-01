//
//  CourseMaterialsTableViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/15/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "CourseMaterialsTableViewController.h"
#import "ManageLayerViewController.h"
#import <Parse/Parse.h>
#import "DataParsing.h"
#import "CourseMaterialTableViewCell.h"
#import "ReaderViewController.h"
#import "ThumbnailPDF.h"
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"
#import "CourseMaterialObject.h"
#import "SVProgressHUD.h"

@interface CourseMaterialsTableViewController () <UIDocumentPickerDelegate,ReaderViewControllerDelegate,UIViewControllerTransitioningDelegate>
{
    BOOL                *isCurrentUserisTeacher;
    NSMutableArray      *coursesMaterialArray;
    NSOperationQueue    *operationQueue;
    bool                isLoadingObjectsFinished;
}
@property (strong, nonatomic) NSString *currentUserFullName;
@property (strong, nonatomic) NSString *currentUserObjectID;
@property (strong, nonatomic) NSString *currentUserName;
@property (strong, nonatomic) NSString *courseMaterialName;
@property (strong, nonatomic) NSData *documentPickerselectedData;

@end

@implementation CourseMaterialsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLoadingObjectsFinished = FALSE;
    
    operationQueue = [[NSOperationQueue alloc] init];
    coursesMaterialArray = [NSMutableArray new];
    
    if ([ManageLayerViewController isCurrentUserisTeacher] == YES){
        //Is a Teacher
        self.addNewMaterilView.hidden       = NO;
        self.addNewMaterialButton.hidden    = NO;
    }else{
        //Is a Student
        self.addNewMaterilView.hidden       = YES;
        self.addNewMaterialButton.hidden    = YES;
    }
    
    [self loadMaterialsObjects];
}

- (void)viewDidAppear:(BOOL)animated{
    if (isLoadingObjectsFinished){
        [SVProgressHUD dismiss];
    }else{
        [SVProgressHUD showWithStatus:@"Loading..."];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [coursesMaterialArray count]? 1: 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [coursesMaterialArray count]? [coursesMaterialArray count]:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    CourseMaterialObject* course= [coursesMaterialArray objectAtIndex:indexPath.row];
    
    cell.materialName.text = course.name;
    cell.TeacherName.text  = course.teacher;
    
    //materialButton action
    cell.materialButton.tag = indexPath.row;
    [cell.materialButton addTarget:self action:@selector(materialButtonViewPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        //Thumbnail
        ThumbnailPDF *thumbPDF = [[ThumbnailPDF alloc] init];
        [thumbPDF startWithCompletionHandler:course.dataFile andSize:500 completion:^(ThumbnailPDF *ThumbnailPDF, BOOL finished) {
            if (finished) {
                cell.materialImageView.image = [UIImage imageWithCGImage:ThumbnailPDF.myThumbnailImage];
            }
        }];
    });
    
    
    return cell;
}



- (void)requestData{
    [self loadMaterialsObjects];
}

/*
 load course materials objects
 */
- (void)loadMaterialsObjects {
    PFQuery *query = [PFQuery queryWithClassName:@"CourseMaterials"];
    [query whereKey:@"cmSubjectName" equalTo:[ManageLayerViewController getDataParsingSubjectName]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Do something with the found objects
            [operationQueue addOperationWithBlock:^{
                [coursesMaterialArray removeAllObjects];
                // Perform long-running tasks without blocking main thread
                for (PFObject *object in objects) {
                    [coursesMaterialArray addObject:[[CourseMaterialObject alloc] initWithObject:object]];
                }
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Main thread work (UI usually)
                    [self.tableView reloadData];
                    isLoadingObjectsFinished = TRUE;
                    [SVProgressHUD dismiss];
                }];
            }];
            
        }else {
            [SVProgressHUD showErrorWithStatus:@"Unable to get course materilas now.Try again!"];
        }
    }];
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
                                                   if (courseMaterialName.text.length > 3) {
                                                       self.courseMaterialName = courseMaterialName.text;
                                                       [self showDocumentPickerInMode:UIDocumentPickerModeOpen];
                                                       
                                                   }else {
                                                       [SVProgressHUD showErrorWithStatus:@"you enter incorrect name,try again!"];
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
//        BOOL startAccessingWorked = [url startAccessingSecurityScopedResource];
//        NSURL *ubiquityURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
//        NSLog(@"ubiquityURL %@",ubiquityURL);
//        NSLog(@"start %d",startAccessingWorked);
        
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
                    NSString *alertMessage = alertMessage = [NSString stringWithFormat:@"Successfully imported %@", [pathURL lastPathComponent]];
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"Import"
                                                          message:alertMessage
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [SVProgressHUD dismiss];
                    [self loadMaterialsObjects];
                    [self.tableView reloadData];
                } else {
                    // There was a problem, check error.description
                    // The object has been saved.
                    [SVProgressHUD dismiss];
                    NSLog(@"Error is %@", error);
                    NSString *alertMessage = alertMessage = [NSString stringWithFormat:@"Ops,UnSuccessfully imported, %@", [pathURL lastPathComponent]];
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"Import Error"
                                                          message:alertMessage
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
            
        } else {
            [SVProgressHUD dismiss];
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
        [SVProgressHUD showProgress:percentDone status:@"uploading file...."];
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
    CourseMaterialObject *courseMaterialObject = [coursesMaterialArray objectAtIndex:indexPath.row];
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:courseMaterialObject.filePath password:nil];
    if (document != nil)
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc]initWithReaderDocument:document];
        readerViewController.delegate = self;
        readerViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        readerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:readerViewController animated:YES completion:nil];
    }else {
        TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:[UIImage imageWithData:courseMaterialObject.dataFile]];
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
