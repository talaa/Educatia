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
#import "RMCustomViewActionController.h"
//#import "RMMapActionController.h"

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
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    RMAction *selectAction = [RMAction<RMCustomViewActionController *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMCustomViewActionController *controller) {
        NSLog(@"Action controller finished successfully");
    }];
    
    RMAction *cancelAction = [RMAction<RMCustomViewActionController *> actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMCustomViewActionController *controller) {
        NSLog(@"Action controller was canceled");
    }];
    
    RMCustomViewActionController *actionController = [RMCustomViewActionController actionControllerWithStyle:style];
    actionController.title = @"Test";
    actionController.message = @"This is a test action controller.\nPlease tap 'Select' or 'Cancel'.";
    
    [actionController addAction:selectAction];
    [actionController addAction:cancelAction];
    

    //On the iPad we want to show the map action controller within a popover. Fortunately, we can use iOS 8 API for this! :)
    //(Of course only if we are running on iOS 8 or later)
    if([actionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //First we set the modal presentation style to the popover style
        actionController.modalPresentationStyle = UIModalPresentationPopover;
        
        //Then we tell the popover presentation controller, where the popover should appear
        actionController.popoverPresentationController.sourceView = self.addNewsView;
        //actionController.popoverPresentationController.sourceRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:actionController animated:YES completion:nil];
    
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
