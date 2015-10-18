//
//  ManageLayerViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TechSubjectCollectionViewCell.h"
#import <Parse/Parse.h>

@interface ManageLayerViewController : UIViewController

+ (void)imageViewLayerProfilePicture:(UIImageView*)imageView Corner:(float)cornerFloat;
+ (void)cellLayerSubjectsCollectionView:(UICollectionViewCell*)cell;
+ (void)imageViewCellAssignment:(UIImageView*)imageView;
+ (void)buttonLayerMainView:(UIButton*)button;
+ (void)cellLayerTechSubjectCollectionView:(TechSubjectCollectionViewCell*)cell;
+ (PFUser*)getCurrentUserObject;
+ (NSString *)getCurrentUserName;
+ (NSString *)getCurrentUserID;
+ (NSString *)getCurrentFullName;
+ (BOOL)isCurrentUserisTeacher;
+ (NSString*)getDataParsingSubjectName;
+ (NSString*)getDataParsingSubjectID;
@end
