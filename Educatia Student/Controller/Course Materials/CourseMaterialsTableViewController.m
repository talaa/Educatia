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

@interface CourseMaterialsTableViewController () <UIDocumentPickerDelegate>

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
                                                   UITextField *subjectNameTextField = alertController.textFields.firstObject;
                                                   
                                                   //start ActivityIndicator
                                                   [self activityLoadingwithLabel];
//
                                                   if (subjectNameTextField.text.length > 0) {
//                                                       UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.image"] inMode:UIDocumentPickerModeImport];
                                                
                                                       
                                                       [self showDocumentPickerInMode:UIDocumentPickerModeOpen];
                                                    
                                                       //[self showDocumentPickerInMode:UIDocumentPickerModeOpen];
                                                       //PFObject *subject = [PFObject objectWithClassName:@"Subjects"];
//
//                                                       subject[@"subjectName"]   = subjectNameTextField.text;
//                                                       subject[@"teacherUserName"] = _teacherUserName;
//                                                       subject[@"teacherFullName"] = _teacherFullName;
//                                                       
//                                                       [subject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                         //Stop ActivityIndicator
                                                          [self activityStopLoading];
//                                                           if (succeeded) {
//                                                               // The object has been saved.
//                                                               [self activityCompletedSuccessfully];
//                                                               //After add then reload collectionView
//                                                               [self viewDidAppear:YES];
//                                                           } else {
//                                                               // There was a problem, check error.description
//                                                               [self activityError];
//                                                           }
//                                                       }];
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
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        NSString *alertMessage = [NSString stringWithFormat:@"Successfully imported %@", [url lastPathComponent]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Import"
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
}

- (NSArray*)allowedUTIs{
    return @[@"kUTTypeContent",@"kUTTypeItem",@"public.audiovisual-content",@"public.movie",@"public.audiovisual-content",@"public.video",@"public.audio",@"public.text",@"public.data",@"public.zip-archive",@"com.pkware.zip-archive",@"public.composite-content",@"public.text"];
}
@end
