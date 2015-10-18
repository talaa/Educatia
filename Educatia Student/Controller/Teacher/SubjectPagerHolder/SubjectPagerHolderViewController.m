//
//  SubjectPagerHolderViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/15/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "SubjectPagerHolderViewController.h"
#import "DataParsing.h"

@interface SubjectPagerHolderViewController ()
{
    NSMutableArray *controllerArray;
    NSArray *titlesArray;
    NSArray *viewControllersArray;
}

@end


@implementation SubjectPagerHolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set SubjectName and SubjectIS
    DataParsing *obj=[DataParsing getInstance];
    obj.subjectName = self.subjectName;
    obj.subjectID   = self.subjectID;
    
    self.navigationItem.title = _subjectName;
    
    titlesArray = @[@"Course Materials",
                    //@"News",@"Grades",@"Assignements",@"Chat",
                    @"Subject Info"];
    viewControllersArray = @[@"CourseMaterialsTableViewController",
                             //@"NewsViewController",@"GradesViewController",@"AssignementsViewController",@"ChatViewController",
                             @"SubjectInfoViewController"];
    
    [self showTabsView];
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

- (IBAction)dismissPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PagerMenu

-(void)showTabsView{
    controllerArray = [NSMutableArray array];
    for (int i=0 ; i< 2 ; i++){
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
    NSLog(@"Moved to %ld", (long)index);
}

-(void)didMoveToPage:(UIViewController *)viewController index:(NSInteger)index{
}

@end
