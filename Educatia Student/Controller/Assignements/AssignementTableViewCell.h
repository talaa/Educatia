//
//  AssignementTableViewCell.h
//  Educatia Student
//
//  Created by Mena Bebawy on 9/14/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssignementTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *assignmentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *assignementImageView;
@property (weak, nonatomic) IBOutlet UIButton *submitSolutionButton;
@property (weak, nonatomic) IBOutlet UIButton *assignmentViewButton;

@end
