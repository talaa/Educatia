//
//  AppDelegate.m
//  Educatia Student
//
//  Created by Tamer Alaa on 8/19/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "NHNetworkTime.h"
#import "ManageLayerViewController.h" 

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //send a notification to NSNotificationCenter:
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewMessage" object:self];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current Installation and save it to Parse
    // Add devices ti Students chanal
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:@"Students" forKey:@"channels"];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"QwpOpbUbYHM0QWVUZtckgf7cffElebexiimTCLCV"
                  clientKey:@"PV1x5enMX9B6QlPHX7sn2AjED18XfTSMPZGBzgdp"];
    
    //Parse Push Notifications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes  categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    //check if user had logged in on previous //////////////////////////////////////
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PFUser *user = [PFUser currentUser];
    if(user){
        [ManageLayerViewController setDataParsingCurrentUserObject:user];
//        if ([ManageLayerViewController getDataParsingIsCurrentTeacher]){
//            self.tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TeacherTabBarViewController"];
//        }else{
//            self.tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"StudentTabBarHolderController"];
//        }
        self.tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"UserTabBarController"];
        [self.window setRootViewController:self.tabBarController];
    }else {
        
        UIViewController *LoginViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.window setRootViewController:LoginViewController];
    }
    //////////////////////////////////////////////// */

    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //synchronize time from server
    [[NHNetworkClock sharedNetworkClock] syncWithComplete:^{
        NSLog(@"huync - %s - Time synced %@", __PRETTY_FUNCTION__, [NSDate networkDate]);
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
