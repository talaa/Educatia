//
//  ChatViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewController.h"

@interface ChatViewController () <UIScrollViewDelegate, UITextFieldDelegate>

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    
//    ChatTableViewController* chatTVC = (ChatTableViewController*)[storyboard instantiateInitialViewController];
    
    ChatTableViewController *chatTVC = (ChatTableViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ChatTableViewController"];
    chatTVC = [[ChatTableViewController alloc] init];
    [self addChildViewController:chatTVC];
    [self chatTableViewControllerView];
//    self.chatTableViewControllerView.layer.backgroundColor =  [UIColor clearColor].CGColor;
//    chatTVC.view.layer.backgroundColor = [UIColor clearColor].CGColor;
//    chatTVC.tableView.layer.backgroundColor = [UIColor clearColor].CGColor;
    [self.chatTableViewControllerView addSubview:chatTVC.view];
    chatTVC.view.frame = self.chatTableViewControllerView.bounds;
    
//    ChatTableViewController *chatTVC = [[ChatTableViewController alloc] init];
//    [self addChildViewController:chatTVC];
//    [self.chatTableViewControllerView setAutoresizesSubviews:NO];
//    [self.chatTableViewControllerView addSubview:chatTVC.tableView];
    
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
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postPressed:(id)sender {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
