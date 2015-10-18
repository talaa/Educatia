//
//  TechSubjectsCollectionViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/15/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//
#import "RNActivityView.h"
#import "UIView+RNActivityView.h"
#import "TechSubjectsCollectionViewController.h"
#import <Parse/Parse.h>
#import "TechSubjectCollectionViewCell.h" 
#import "ManageLayerViewController.h"
#import "SubjectPagerHolderViewController.h"

@interface TechSubjectsCollectionViewController ()

@property (strong, nonatomic) NSString *subjectName;
@property (strong, nonatomic) NSString *teacherFirstName;
@property (strong, nonatomic) NSString *teacherLastName;
@property (strong, nonatomic) NSString *teacherFullName;
@property (strong, nonatomic) NSString *teacherUserName;
@property (strong, nonatomic) NSMutableArray *subjectsNameMArray;
@property (strong, nonatomic) NSMutableArray *subjectsIDMArray;

@end

@implementation TechSubjectsCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [self getCurrentUserData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self loadSubjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
     NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
     
     if ([segue.identifier isEqualToString:@"SubjectSegue"]) {
         UINavigationController *nav = [segue destinationViewController];
         SubjectPagerHolderViewController *subHolderVC = (SubjectPagerHolderViewController *)nav.topViewController;
         subHolderVC.subjectName    = [_subjectsNameMArray objectAtIndex:indexPath.row];
         subHolderVC.subjectID      = [_subjectsIDMArray objectAtIndex:indexPath.row];
     }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //#warning Incomplete method implementation -- Return the number of sections
    return [_subjectsNameMArray count]? 1:0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //#warning Incomplete method implementation -- Return the number of items in the section
    return [_subjectsNameMArray count]? [_subjectsNameMArray count]:0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TechSubjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    if ([_subjectsNameMArray count]>0){
        cell.subjectName.text = [_subjectsNameMArray objectAtIndex:indexPath.row];
    }
    [ManageLayerViewController cellLayerTechSubjectCollectionView:cell];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
- (void)collectionView:(UICollectionView *)collectionView SelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _subjectName = [_subjectsNameMArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"SubjectSegue" sender:self];
}
*/

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

- (IBAction)addNewSubjectPressed:(id)sender {
    [self presentAlretController];
}

/*
 UIAlertController
 */
- (void)presentAlretController {
    UIAlertController * alertController=   [UIAlertController
                                            alertControllerWithTitle:@"New Subject"
                                            message:@"Enter New Subject Name"
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Do Some action here ---> OK
                                                   UITextField *subjectNameTextField = alertController.textFields.firstObject;
                                                   
                                                   //start ActivityIndicator
                                                   [self activityLoadingwithLabel];
                                                   
                                                   if (subjectNameTextField.text.length > 0) {
                                                       PFObject *subject = [PFObject objectWithClassName:@"Subjects"];
                                                       
                                                       subject[@"subjectName"]   = subjectNameTextField.text;
                                                       subject[@"teacherUserName"] = _teacherUserName;
                                                       subject[@"teacherFullName"] = _teacherFullName;
                                                       
                                                       [subject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                           //Stop ActivityIndicator
                                                           [self activityStopLoading];
                                                           if (succeeded) {
                                                               // The object has been saved.
                                                               [self activityCompletedSuccessfully];
                                                               //After add then reload collectionView
                                                               [self viewDidAppear:YES];
                                                           } else {
                                                               // There was a problem, check error.description
                                                               [self activityError];
                                                           }
                                                       }];
                                                   }else {
                                                       [self activityError];
                                                   }
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action) {
                                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField* textField) {
        textField.placeholder = @"Subject Name";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
 ShowActivity Methos
 */

- (void)activityCompletedSuccessfully {
    [self.view showActivityViewWithLabel:@"Subject has been added" image:[UIImage imageNamed:@"37x-Checkmark.png"]];
    [self.view hideActivityViewWithAfterDelay:2];
}

- (void)activityError {
    [self.view showActivityViewWithLabel:@"Error,Try again!" image:[UIImage imageNamed:@"32x-Closemark.png"]];
    [self.view hideActivityViewWithAfterDelay:2];
}

- (void)activityLoadingwithLabel {
    [self.view showActivityViewWithLabel:@"Loading...."];
}

- (void)activityStopLoading {
    [self.view hideActivityView];
}

/*
 Load Objects from Parse
 */

- (void)loadSubjects {
    [self activityLoadingwithLabel];
    PFQuery *query = [PFQuery queryWithClassName:@"Subjects"];
    [query whereKey:@"teacherUserName" equalTo:_teacherUserName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Retrieved scores successfully
            _subjectsNameMArray = [[NSMutableArray alloc] init];
            _subjectsIDMArray   = [[NSMutableArray alloc] init];
            for (PFObject *object in objects){
                [_subjectsNameMArray addObject:object[@"subjectName"]];
                [_subjectsIDMArray addObject:object.objectId];
            }
            [self activityStopLoading];
            [self.collectionView reloadData];
        }
    }];
}

/*
 get current user data
 */
- (void)getCurrentUserData {
    //Save new subject object
    PFUser *user = [PFUser currentUser];
    self.teacherUserName = user.username;
    self.teacherFirstName = user[@"FirstName"];
    self.teacherLastName = user[@"LastName"];
    self.teacherFullName = [[_teacherFirstName stringByAppendingString:@" "] stringByAppendingString:_teacherLastName];
}


@end
