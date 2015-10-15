//
//  TabBarPagerHolderViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPSPageMenu.h"

@interface TabBarPagerHolderViewController : UIViewController <CAPSPageMenuDelegate>

@property (nonatomic) CAPSPageMenu *pagemenu;

- (IBAction)dismissPressed:(id)sender;

@end
