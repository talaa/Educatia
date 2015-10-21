//
//  CourseMaterialsTableViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 10/15/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseMaterialsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIView *addNewMaterilView;
@property (weak, nonatomic) IBOutlet UIButton *addNewMaterialButton;

- (IBAction)addNewMaterialPressed:(id)sender;
@end
