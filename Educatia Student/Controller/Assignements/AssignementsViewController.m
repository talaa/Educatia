//
//  AssignementsViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "AssignementsViewController.h"
#import "AssignementTableViewCell.h"
#import <Parse/Parse.h>
#import "ManageLayerViewController.h"

@interface AssignementsViewController ()
@property (strong, nonatomic) NSMutableArray *teacherMArray;
@property (strong, nonatomic) NSMutableArray *maxScoreMArray;
@property (strong, nonatomic) NSMutableArray *deadLineMArray;
@property (strong, nonatomic) NSMutableArray *pdfPathMArray;
@end

@implementation AssignementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadAssignementObjects];
}

- (void) viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAssignementObjects {
    //[self showPlayLoadActivity];
    PFQuery *query = [PFQuery queryWithClassName:@"Assignement"];
    [query whereKey:@"Subject" equalTo:@"Math"];
    NSArray *objects = [query findObjects];
    _teacherMArray  = [[NSMutableArray alloc] init];
    _maxScoreMArray = [[NSMutableArray alloc] init];
    _deadLineMArray = [[NSMutableArray alloc] init];
    _pdfPathMArray  = [[NSMutableArray alloc] init];
    
    // The find succeeded.
    NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
    // Do something with the found objects
    for (PFObject *object in objects) {
        [self.teacherMArray addObject:object[@"Teacher"]];
        [self.maxScoreMArray addObject:[NSString stringWithFormat:@"%@",object[@"MaximumScore"]]];
        //convert date to string
        NSString *deadLineString = [self convertDateToString:object[@"Dead_line_date"]];
        [self.deadLineMArray addObject:deadLineString];
        //get pdf file
        PFFile *pdfFile = object[@"File"];
        NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pdfFile.url]];
        // Store the Data locally as PDF File
        NSString *resourceDocPath = [[NSString alloc] initWithString:[
                                                                      [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
                                                                      stringByAppendingPathComponent:@"Educatia Student.app/"
                                                                      ]];
        NSString *fileName = [object.objectId stringByAppendingString:@".pdf"];
        NSString *filePath = [resourceDocPath stringByAppendingPathComponent:fileName];
        [pdfData writeToFile:filePath atomically:YES];
        [_pdfPathMArray addObject:filePath];
    }
}


//PFQuery *query = [PFQuery queryWithClassName:@"Assignement"];
/*
 [query getObjectInBackgroundWithId:@"Tx9V8IEbaa" block:^(PFObject *materialFile, NSError *error) {
 // Do something with the returned PFObject in the materialFile variable.
 PFFile *pdfFile = materialFile[@"material"];
 [pdfFile getDataInBackgroundWithBlock:^(NSData *pdfFileData, NSError *error) {
 if (!error) {
 // Get the PDF Data from the url in a NSData Object
 pdfFileData = [[NSData alloc] initWithContentsOfURL:[
 NSURL URLWithString:pdfFile.url]];
 
 // Store the Data locally as PDF File
 NSString *resourceDocPath = [[NSString alloc] initWithString:[
 [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
 stringByAppendingPathComponent:@"Educatia Student.app/"
 ]];
 _filePath = [resourceDocPath
 stringByAppendingPathComponent:@"myPDF.pdf"];
 [pdfFileData writeToFile:_filePath atomically:YES];
 
 ThumbnailPDF *thumbPDF = [[ThumbnailPDF alloc] init];
 [thumbPDF startWithCompletionHandler:pdfFileData andSize:500 completion:^(ThumbnailPDF *ThumbnailPDF, BOOL finished) {
 if (finished) {
 _imageView.image = [UIImage imageWithCGImage:ThumbnailPDF.myThumbnailImage];
 [self stopHideLoadingActivity];
 }
 }];
 }}];
 }];
 */


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return (self.teacherMArray.count)?(self.teacherMArray.count):0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssignementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    //Load Objects
    cell.teacherNameLabel.text  = [self.teacherMArray objectAtIndex:indexPath.row];
    cell.maxScoreLabel.text     = [self.maxScoreMArray objectAtIndex:indexPath.row];
    cell.deadLineLabel.text     = [self.deadLineMArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(NSString*)convertDateToString:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSLog(@"The Date: %@", dateString);
    return dateString;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
