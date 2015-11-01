//
//  SubjectInfoViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 10/15/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubjectInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *subjectLogoImageView;
@property (weak, nonatomic) IBOutlet UIButton *uploadLogoButton;
@property (weak, nonatomic) IBOutlet UIButton *changeLogoButton;

- (IBAction)uploadLogoPressed:(id)sender;
- (IBAction)changeLogoPressed:(id)sender;

@end
