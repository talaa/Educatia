//
//  AssignmentsTableViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 10/21/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"

@interface AssignmentsTableViewController : UITableViewController <UIViewControllerTransitioningDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *addNewAssignmentView;
@property (weak, nonatomic) IBOutlet UIButton *addNewAssignmentButton;

-(IBAction)addNewAssignmentPressed:(id)sender;
@end
