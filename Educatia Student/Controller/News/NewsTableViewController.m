//
//  NewsTableViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 11/11/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewsTableViewCell.h"
#import "ManageLayerViewController.h"
#import "NewsObject.h"
#import "SVProgressHUD.h"
#import "ManageLayerViewController.h"

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLoadingObjectsFinished = FALSE;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Loading...";
    
    operationQueue      = [[NSOperationQueue alloc] init];
    mainQueue           = [NSOperationQueue mainQueue];
    newsMArray          = [NSMutableArray new];
    
    if ([ManageLayerViewController getDataParsingIsCurrentTeacher]) {
        self.addNewsView.hidden = NO;
    }else {
        self.addNewsView.hidden = YES;
    }
    
    [self loadNewsObjects];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [newsMArray count]? 1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [newsMArray count]?[newsMArray count]:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NewsObject *newsObject = [newsMArray objectAtIndex:indexPath.row];
    cell.newsSubject.text = newsObject.subject;
    cell.newsTextView.text = newsObject.text;
    cell.newsCreatedAtLabel.text = [self convertDateToString:newsObject.date];
    return cell;
}

- (IBAction)addNewsPressed:(id)sender {
    [self presentAlertController];
}

/**
 *
 *
 *************** Load Objects ******************
 *
 *
 **/
- (void)loadNewsObjects{
    PFQuery *query = [PFQuery queryWithClassName:@"News"];
    NSString *subjID = [ManageLayerViewController getDataParsingSubjectID];
    [query whereKey:@"subjectID" equalTo:subjID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [operationQueue addOperationWithBlock:^{
                [newsMArray removeAllObjects];
                // Perform long-running tasks without blocking main thread
                for (PFObject *object in objects) {
                    [newsMArray addObject:[[NewsObject alloc] initWithObject:object]];
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
 ********** Presenting AlertController *************
 *
 */
-(void)presentAlertController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add News" message:@"Kindly enter news name and text" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Name...";
        textField.returnKeyType = UIReturnKeyDone;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //
        CGRect frameRect = textField.frame;
        frameRect.size.height = 53;
        textField.frame = frameRect;
        textField.placeholder = @"Text...";
        textField.returnKeyType = UIReturnKeyDone;
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //code
        UITextField *subjectTextfield = alertController.textFields.firstObject;
        UITextField *textTextfield = alertController.textFields.lastObject;
        
        if (subjectTextfield.text.length >0 && textTextfield.text.length >0){
            [self saveNewsSubject:subjectTextfield.text Text:textTextfield.text];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"Kindly don't forget to fill Subject and Text"];
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //Code
    }];
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


/*
 *
 *********** Save News On Parse *************
 *
 */

- (void)saveNewsSubject:(NSString*)subject Text:(NSString*)text{
    [SVProgressHUD showWithStatus:@"Adding news..."];
    PFObject *newsObject        = [PFObject objectWithClassName:@"News"];
    newsObject[@"subjectID"]    = [ManageLayerViewController getDataParsingSubjectID];
    newsObject[@"newsSubject"]  = subject;
    newsObject[@"newsText"]     = text;
    [newsObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"Nes has been added Successfully"];
            [self loadNewsObjects];
        } else {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"An error has been occured,Try again!"];
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
@end
