//
//  CourseMaterialsViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
typedef void (^CompletionHandler)(BOOL);

@interface CourseMaterialsViewController : UIViewController <ReaderViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingPDfActivityIndicator;
@property (strong, nonatomic) IBOutlet NSString *filePath;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)didClickOpenPDF:(id)sender;

@end
