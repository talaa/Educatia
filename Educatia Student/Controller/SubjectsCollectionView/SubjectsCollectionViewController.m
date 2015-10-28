//
//  SubjectsCollectionViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "SubjectsCollectionViewController.h"
#import "ManageLayerViewController.h"
#import "TabBarPagerHolderViewController.h"
#import "SubjectCollectionViewCell.h"
#import "RNActivityView.h"
#import "UIView+RNActivityView.h"
#import <Parse/Parse.h>

@interface SubjectsCollectionViewController ()

@property (strong, nonatomic) NSString *subjectName;
@property (strong, nonatomic) NSString *studentName;
@property (strong, nonatomic) NSString *studentUsername;
@property (strong, nonatomic) NSString *studentID;
@property (strong, nonatomic) NSMutableArray *subjectsNameMArray;
@property (strong, nonatomic) NSMutableArray *subjectsIDMArray;

@end

@implementation SubjectsCollectionViewController

static NSString * const reuseIdentifier = @"SubjectCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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
        TabBarPagerHolderViewController *subHolderVC = (TabBarPagerHolderViewController *)nav.topViewController;
        subHolderVC.subjectName    = [_subjectsNameMArray objectAtIndex:indexPath.row];
        subHolderVC.subjectID      = [_subjectsIDMArray objectAtIndex:indexPath.row];
    }
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //#warning Incomplete method implementation -- Return the number of sections
    return [_subjectsIDMArray count]? 1:0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //#warning Incomplete method implementation -- Return the number of items in the section
    return [_subjectsIDMArray count]? [_subjectsIDMArray count]:0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SubjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    if ([_subjectsNameMArray count]>0){
        cell.subjectNameLabel.text = [_subjectsNameMArray objectAtIndex:indexPath.row];
    }
    [ManageLayerViewController subjectCollectionViewCellLayer:cell];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

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

/*
 Add New Subject Pressed Button Action
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
                                            message:@"Enter Subject ID"
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //Do Some action here ---> OK
        UITextField *subjectIDTextField = alertController.textFields.firstObject;
        //start ActivityIndicator
        //[self activityLoadingwithLabel];
        
        if (subjectIDTextField.text.length > 9) {
            //search by SubjectID to get subjectName
            PFQuery *query = [PFQuery queryWithClassName:@"Subjects"];
            [query whereKey:@"objectId" equalTo:subjectIDTextField.text];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error && ([objects count]>0)) {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved scores.");
                    // Do something with the found objects To get SubjectName
                    for (PFObject *object in objects) {
                        _subjectName = object[@"subjectName"];
                    }
                    //save StudentSubjects table by subject ID and subject Name
                    [self saveStudentSubjectsbySubjectID:subjectIDTextField.text andSubjectName:_subjectName];
                } else {
                    // Log details of the failure
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Incorrect Subject ID.Try again." preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
        }else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add New Subject" message:@"You have entered ID less than the correct one!" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action) {
                                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField* textField) {
        textField.placeholder = @"Subject ID";
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
 ******* Save Student Sujects on Parse StudentSubjects table *****************
 */

- (void)saveStudentSubjectsbySubjectID:(NSString*)subjectID andSubjectName:(NSString*)subjectName {
    PFObject *studentSubjectsObject = [PFObject objectWithClassName:@"StudentSubjects"];
    studentSubjectsObject[@"subjectName"]       = subjectName;
    studentSubjectsObject[@"subjectID"]         = subjectID;
    //Get Student Data --> ID, Username and Full Name
    [self setStudentData];
    studentSubjectsObject[@"studentID"]         = _studentID;
    studentSubjectsObject[@"studentUserName"]   = _studentUsername;
    studentSubjectsObject[@"studentName"]       = _studentName;
    //Save data
    [studentSubjectsObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        UIAlertController *alertController;
        if (succeeded) {
            [self loadSubjects];
            alertController = [UIAlertController alertControllerWithTitle:@"Add New Subject" message:@"Subject has been added sussuccefully." preferredStyle:UIAlertControllerStyleAlert];
        } else {
            alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Try again!!" preferredStyle:UIAlertControllerStyleAlert];
        }
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)setStudentData {
    _studentID          = [ManageLayerViewController getCurrentUserID];
    _studentName        = [ManageLayerViewController getCurrentFullName];
    _studentUsername    = [ManageLayerViewController getCurrentUserName];
}

/*
 Load Objects from Parse
 */

- (void)loadSubjects {
    [self activityLoadingwithLabel];
    PFQuery *query = [PFQuery queryWithClassName:@"StudentSubjects"];
    [self setStudentData];
    [query whereKey:@"studentID" equalTo:_studentID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Retrieved scores successfully
            _subjectsNameMArray = [[NSMutableArray alloc] init];
            _subjectsIDMArray   = [[NSMutableArray alloc] init];
            for (PFObject *object in objects){
                [_subjectsNameMArray addObject:object[@"subjectName"]];
                [_subjectsIDMArray addObject:object[@"subjectID"]];
            }
            [self activityStopLoading];
            [self.collectionView reloadData];
        }
    }];
}
@end
