//
//  SubjectInfoViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/15/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "SubjectInfoViewController.h"
#import <Parse/Parse.h>
#import "SubjectObject.h"
#import "SVProgressHUD.h"
#import "ManageLayerViewController.h"

@interface SubjectInfoViewController ()
{
    NSMutableArray *subjectObjectMArray;
}
@end

@implementation SubjectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubjectData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 *
 ******* Load Subject's Data ********
 *
 */
- (void)loadSubjectData{
    PFQuery *query = [PFQuery queryWithClassName:@"Subjects"];
    [query whereKey:@"objectId" equalTo:[ManageLayerViewController getDataParsingSubjectID]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                self.codeLabel.text = object.objectId;
                self.subjectLabel.text = object[@"subjectName"];
                self.teacherLabel.text = object[@"teacherFullName"];
                //load image
                PFFile *subjectLogoFile = object[@"subjectLogo"];
                [subjectLogoFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (!error) {
                        self.subjectLogoImageView.image = [UIImage imageWithData:imageData];
                    }
                }];
            }
        } else {
            // Log details of the failure
            [SVProgressHUD showErrorWithStatus:@"Can't get data now.Try again!"];
        }
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
