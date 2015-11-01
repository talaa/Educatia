//
//  ChatViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.


#import "ChatViewController.h"
#import "ChatTableViewController.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>

@interface ChatViewController () <UIScrollViewDelegate, UITextFieldDelegate,MBProgressHUDDelegate>
{
    ChatTableViewController *chatTVC;
    MBProgressHUD *HUD;
}

@end

#define chatBOOL NO

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (chatBOOL == NO){
        
    } else {
        // Presentting ChatTableViewController TableView on chattingTableViewControllerView
        chatTVC = (ChatTableViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ChatTableViewController"];
        chatTVC = [[ChatTableViewController alloc] init];
        [self addChildViewController:chatTVC];
        [self chatTableViewControllerView];
        [self.chatTableViewControllerView addSubview:chatTVC.view];
        chatTVC.view.frame = self.chatTableViewControllerView.bounds;
        
        
        // For dismissing keyboard  /////////////////////////
        [self.view addGestureRecognizer:
         [[UITapGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(hideKeyboard:)]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        /////////////////////////////////////////////////
        
        //Notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"NewMessage" object:nil];
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (chatBOOL == NO){
        //Loading Activity
        [self myProgressTask];
    }else{
        
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    //[SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postPressed:(id)sender {
    if (self.textPostTextField.text.length > 0) {
        [self hideKeyboard:self];
        PFObject *postObject    = [PFObject objectWithClassName:@"Posts"];
        postObject[@"post"]     = self.textPostTextField.text;
        postObject[@"username"] = [PFUser currentUser].username;
        postObject[@"sentTo"]   = @"Students";
        
        [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
                self.textPostTextField.text = @"";
                NSLog(@"Messgae Saved");
                [chatTVC viewDidAppear:YES];
                // Send a notification to all devices subscribed to the "Students" channel.
                PFPush *push = [[PFPush alloc] init];
                [push setChannel:@"Students"];
                [push setMessage:self.textPostTextField.text];
                [push sendPushInBackground];
            } else {
                // There was a problem, check error.description
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Educatia Student" message:@"An error has been happened" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }
}

#pragma mark -
#pragma mark Keyboard

- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    [self moveControls:notification up:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    [self moveControls:notification up:NO];
}

- (void)moveControls:(NSNotification*)notification up:(BOOL)up
{
    NSDictionary* userInfo = [notification userInfo];
    CGRect newFrame = [self getNewControlsFrame:userInfo up:up];
    
    [self animateControls:userInfo withFrame:newFrame];
}

- (CGRect)getNewControlsFrame:(NSDictionary*)userInfo up:(BOOL)up
{
    CGRect kbFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbFrame = [self.view convertRect:kbFrame fromView:nil];
    
    CGRect newFrame = self.view.frame;
    newFrame.origin.y += kbFrame.size.height * (up ? -1 : 1);
    
    return newFrame;
}

- (void)animateControls:(NSDictionary*)userInfo withFrame:(CGRect)newFrame
{
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:animationOptionsWithCurve(animationCurve)
                     animations:^{
                         self.view.frame = newFrame;
                     }
                     completion:^(BOOL finished){}];
}

static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve)
{
    return (UIViewAnimationOptions)curve << 16;
}

#pragma mark - RecieveNotificationDelegete

- (void)receiveNotification:(NSNotification *) notification {
    
    if ([[notification name] isEqualToString:@"NewMessage"]) {
        [chatTVC viewDidAppear:YES];
    }
}

#pragma mark - Progress

- (void)myProgressTask {
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    HUD.labelText = @"Chat is Coming Soon...";
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


@end
