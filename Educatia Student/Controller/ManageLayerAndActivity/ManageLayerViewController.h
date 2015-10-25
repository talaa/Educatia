//
//  ManageLayerViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectCollectionViewCell.h"
#import <Parse/Parse.h>

@interface ManageLayerViewController : UIViewController

+ (void)imageViewLayerProfilePicture:(UIImageView*)imageView Corner:(float)cornerFloat;
+ (void)cellLayerSubjectsCollectionView:(UICollectionViewCell*)cell;
+ (void)imageViewCellAssignment:(UIImageView*)imageView;
+ (void)buttonLayerMainView:(UIButton*)button;
+ (void)subjectCollectionViewCellLayer:(SubjectCollectionViewCell*)cell;
+ (PFUser*)getCurrentUserObject;
+ (NSString *)getCurrentUserName;
+ (NSString *)getCurrentUserID;
+ (NSString *)getCurrentFullName;
+ (BOOL)isCurrentUserisTeacher;
+ (void)setDataParsingCurrentUserObject;
+ (NSString*)getDataParsingSubjectName;
+ (NSString*)getDataParsingSubjectID;
+ (BOOL)getDataParsingIsCurrentTeacher;
+ (NSString *)getDataParsingCurrentuserID;
+ (NSString*)getDataParsingCurrentusername;
+ (NSString*)getDataParsingCurrentName;

@end
