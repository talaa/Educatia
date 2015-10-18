//
//  CourseMaterialTableViewCell.h
//  Educatia Student
//
//  Created by Mena Bebawy on 10/18/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseMaterialTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *materialImageView;
@property (weak, nonatomic) IBOutlet UILabel *materialName;
@property (weak, nonatomic) IBOutlet UILabel *TeacherName;

@end
