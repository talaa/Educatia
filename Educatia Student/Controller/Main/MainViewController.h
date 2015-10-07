//
//  MainViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 10/7/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *studentButton;
@property (weak, nonatomic) IBOutlet UIButton *teacherButton;
- (IBAction)studentButtonPressed:(id)sender;
- (IBAction)teacherButtonPressed:(id)sender;
@end
