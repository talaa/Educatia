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

@interface TechSubjectsCollectionViewController ()

@property (strong, nonatomic) NSString *teacherFirstName;
@property (strong, nonatomic) NSString *teacherLastName;
@property (strong, nonatomic) NSString *teacherFullName;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //#warning Incomplete method implementation -- Return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //#warning Incomplete method implementation -- Return the number of items in the section
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
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
                                                   if (subjectNameTextField.text.length > 0) {
                                                       
                                                       //start ActivityIndicator
                                                       

                                                       //Save new subject object
                                                       PFUser *user = [PFUser currentUser];
                                                       self.teacherFirstName = user[@"FirstName"];
                                                       self.teacherLastName = user[@"LastName"];
                                                       self.teacherFullName = [[_teacherFirstName stringByAppendingString:@" "] stringByAppendingString:_teacherLastName];
                                                       
                                                       PFObject *subject = [PFObject objectWithClassName:@"Subjects"];
                                                       
                                                       subject[@"subjectName"]   = subjectNameTextField.text;
                                                       subject[@"teacherUserName"] = user.username;
                                                       subject[@"teacherFullName"] = _teacherFullName;
                                                       
                                                       [subject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                           //Stop ActivityIndicator
                                                           
                                                           if (succeeded) {
                                                               // The object has been saved.
                                                               [self.view showActivityViewWithLabel:@"Subject has been added" image:[UIImage imageNamed:@"37x-Checkmark.png"]];
                                                               [self.view hideActivityViewWithAfterDelay:2];
                                                           } else {
                                                               // There was a problem, check error.description
                                                               [self.view showActivityViewWithLabel:@"Error.Try again!" image:[UIImage imageNamed:@"32x-Closemark.png"]];
                                                               [self.view hideActivityViewWithAfterDelay:2];
                                                           }
                                                       }];
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

@end
