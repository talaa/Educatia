//
//  AssignmentsTableViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 10/21/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssignmentsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIView *addNewAssignmentView;
@property (weak, nonatomic) IBOutlet UIButton *addNewAssignmentButton;
- (IBAction)addNewAssignmentPressed:(id)sender;
@end
