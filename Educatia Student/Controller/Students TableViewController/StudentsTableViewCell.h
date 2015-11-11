//
//  StudentsTableViewCell.h
//  Educatia Student
//
//  Created by Mena Bebawy on 11/11/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *studentImageView;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentMobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentMailLabel;
@end
