//
//  StudentsTableViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 11/11/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import "StudentsTableViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "ManageLayerViewController.h"
#import "StudentSubjects.h"
#import "StudentsTableViewCell.h"

@interface StudentsTableViewController () <MBProgressHUDDelegate>
{
    NSMutableArray *studentsMArray;
    NSOperationQueue    *operationQueue;
    NSOperationQueue    *mainQueue;
    bool                isLoadingObjectsFinished;
    MBProgressHUD       *HUD;
}

@end

@implementation StudentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLoadingObjectsFinished = FALSE;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Loading...";
    
    operationQueue      = [[NSOperationQueue alloc] init];
    mainQueue           = [NSOperationQueue mainQueue];
    studentsMArray      = [NSMutableArray new];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Load Objects
    [self loadStudentsObjects];
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
    //#warning Incomplete implementation, return the number of sections
    return [studentsMArray count]?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return [studentsMArray count]?[studentsMArray count]:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    StudentSubjects *studentSubjectObj = [studentsMArray objectAtIndex:indexPath.row];
    cell.studentNameLabel.text              = studentSubjectObj.studentName;
    cell.studentMobileLabel.text            = studentSubjectObj.studentPhone;
    cell.studentMailLabel.text              = studentSubjectObj.studentEmail;
    cell.studentImageView.image             = [UIImage imageWithData:studentSubjectObj.studentProfilePic];
    cell.studentImageView.layer.cornerRadius = 30.0f;
    cell.studentImageView.layer.masksToBounds = YES;
    
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
 *
 ***************** Load students Objects ***************
 *
 */

- (void)loadStudentsObjects {
    PFQuery *query = [PFQuery queryWithClassName:@"StudentSubjects"];
    NSString *subjID = [ManageLayerViewController getDataParsingSubjectID];
    [query whereKey:@"subjectID" equalTo:subjID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [operationQueue addOperationWithBlock:^{
                [studentsMArray removeAllObjects];
                // Perform long-running tasks without blocking main thread
                for (PFObject *object in objects) {
                    [studentsMArray addObject:[[StudentSubjects alloc] initWithObject:object]];
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

@end
