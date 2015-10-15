//
//  TechSubjectCollectionViewCell.h
//  Educatia Student
//
//  Created by Mena Bebawy on 10/15/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TechSubjectCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *subjectImage;
@property (strong, nonatomic) IBOutlet UILabel *subjectName;

@end
