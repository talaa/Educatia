//
//  ChatViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface ChatViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UIView *chatTableViewControllerView;
@property (weak, nonatomic) IBOutlet UITextField *textPostTextField;
@property (weak, nonatomic) IBOutlet UIView *writeTextAndPostView;

- (IBAction)postPressed:(id)sender;

@end
