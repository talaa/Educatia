//
//  NewsTableViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 11/11/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import "NewsTableViewController.h"
#import "ManageLayerViewController.h"
#import "NewsObject.h"
#import "SVProgressHUD.h"

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
    
    [self loadAssignmentsObjects];
}

- (IBAction)addNewsPressed:(id)sender {
}

/**
 *
 *
 *************** Load Objects ******************
 *
 *
 **/
- (void)loadAssignmentsObjects{
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
@end
