//
//  SubjectPagerHolderViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 10/15/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPSPageMenu.h"

@interface SubjectPagerHolderViewController : UIViewController <CAPSPageMenuDelegate>

@property (nonatomic) CAPSPageMenu *pagemenu;
@property (strong, nonatomic) NSString *subjectName;

- (IBAction)dismissPressed:(id)sender;

@end
