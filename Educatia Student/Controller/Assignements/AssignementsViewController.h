//
//  AssignementsViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"

typedef void (^CompletionHandler)(BOOL);

@interface AssignementsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UITableView *assingementsTableView;
@property (weak, nonatomic) IBOutlet UIView *addNewAssignmentView;
@property (weak, nonatomic) IBOutlet UIButton *addNewAssignementButton;

- (IBAction)addNewAssignmentPressed:(id)sender;

@end
