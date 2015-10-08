//
//  TeacherTabBarViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 10/8/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "TeacherTabBarViewController.h"
#import "ProfileViewController.h"

@interface TeacherTabBarViewController ()

@end

@implementation TeacherTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    
    ProfileViewController *profile = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    UINavigationController *navigationSubjects = [storyboard instantiateViewControllerWithIdentifier:@"TeacherSubjectNavigationController"];
    
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    [tabViewControllers addObject:profile];
    [tabViewControllers addObject:navigationSubjects];
    
    
    [self setViewControllers:tabViewControllers];
    //can't set this until after its added to the tab bar
    profile.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Profile"
                                  image:[UIImage imageNamed:@"Icon_Profile"]
                                    tag:1];
    navigationSubjects.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Subjects"
                                  image:[UIImage imageNamed:@"Icon_Subjects"]
                                    tag:2];
//    view3.tabBarItem =
//    [[UITabBarItem alloc] initWithTitle:@"view3"
//                                  image:[UIImage imageNamed:@"view3"]
//                                    tag:3];
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

@end
