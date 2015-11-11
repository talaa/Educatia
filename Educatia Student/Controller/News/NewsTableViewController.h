//
//  NewsTableViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 11/11/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIView *addNewsView;

- (IBAction)addNewsPressed:(id)sender;
@end
