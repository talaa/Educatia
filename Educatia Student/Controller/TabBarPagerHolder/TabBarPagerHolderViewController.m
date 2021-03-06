//
//  TabBarPagerHolderViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "TabBarPagerHolderViewController.h"
#import "DataParsing.h"
#import "ManageLayerViewController.h"
#import "SVProgressHUD.h"

@interface TabBarPagerHolderViewController ()
{
    NSMutableArray *controllerArray;
    NSArray *titlesArray;
    NSArray *viewControllersArray;
}


@end

@implementation TabBarPagerHolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.subjectName;
    
    //Set SubjectName and SubjectIS
    DataParsing *obj        = [DataParsing getInstance];
    obj.subjectName         = self.subjectName;
    obj.subjectID           = self.subjectID;
    
    if ([ManageLayerViewController getDataParsingIsCurrentTeacher]){
        //this is a teacher user
        titlesArray = @[@"Assignments",@"Subject Info",@"Course Materials",@"News",@"Students"];
        viewControllersArray = @[@"AssignmentsTableViewController",@"SubjectInfoViewController",@"CourseMaterialsTableViewController",@"NewsTableViewController",@"StudentsTableViewController"];
    }else {
        //this is a student user
        titlesArray = @[@"Course Materials",@"News",@"Grades",@"Assignements",@"Chat",@"Students",@"Subject Info"];
        viewControllersArray = @[@"CourseMaterialsTableViewController",
                                 @"NewsTableViewController",
                                 @"GradesViewController",
                                 @"AssignmentsTableViewController",
                                 @"ChatViewController",
                                 @"StudentsTableViewController",
                                 @"SubjectInfoViewController"];
    }
    
    
    [self showTabsView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

#pragma mark - Tab Pager Data Source
- (NSInteger)numberOfViewControllers {
    return [viewControllersArray count];
}

#pragma mark - PagerMenu

-(void)showTabsView{
    controllerArray = [NSMutableArray array];
    for (int i=0 ; i< [viewControllersArray count] ; i++){
        UIViewController *viewController =  [[self storyboard] instantiateViewControllerWithIdentifier:[viewControllersArray objectAtIndex:i]];
        viewController.title = [titlesArray objectAtIndex:i];
        [controllerArray addObject:viewController];
    }
    
    NSDictionary *parameters = @{CAPSPageMenuOptionMenuItemSeparatorWidth: @(4.3),
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor clearColor],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1],
                                 CAPSPageMenuOptionSelectionIndicatorColor:[UIColor colorWithRed:18.0/255.0 green:150.0/255.0 blue:225.0/255.0 alpha:1],
                                 CAPSPageMenuOptionMenuMargin: @(20.0),
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: [UIColor colorWithRed:18.0/255.0 green:150.0/255.0 blue:225.0/255.0 alpha:1],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor: [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:112.0/255.0 alpha:1],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue-Medium" size:14],
                                 CAPSPageMenuOptionMenuItemSeparatorRoundEdges: @(YES),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES),
                                 CAPSPageMenuOptionMenuItemSeparatorPercentageHeight: @(0.1)
                                 };
    
    // Initialize page menu with controller array, frame, and optional parameters
    _pagemenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 60.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    _pagemenu.delegate = self;
    
    [self.view addSubview:_pagemenu.view];
}

#pragma mark - PagerMenu delegete

-(void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index{
}

-(void)didMoveToPage:(UIViewController *)viewController index:(NSInteger)index{
}

//dismiss Button Action
- (IBAction)dismissPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
