//
//  CourseMaterialsViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "CourseMaterialsViewController.h"
#import <Parse/Parse.h>

@interface CourseMaterialsViewController ()

@end

@implementation CourseMaterialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickOpenPDF:(id)sender{
    PFQuery *query = [PFQuery queryWithClassName:@"CourseMaterials"];
    [query getObjectInBackgroundWithId:@"Tx9V8IEbaa" block:^(PFObject *materialFile, NSError *error) {
        // Do something with the returned PFObject in the materialFile variable.
        PFFile *pdfFile = materialFile[@"material"];
        [pdfFile getDataInBackgroundWithBlock:^(NSData *pdfFileData, NSError *error) {
            if (!error) {
                
                NSURL *myURL = [NSURL URLWithString:[pdfFile.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSString *string = [NSString stringWithContentsOfURL:myURL encoding:NSUTF8StringEncoding error:nil];
                NSLog(@"UEL %@", pdfFile.url);
                ReaderDocument *document = [ReaderDocument withDocumentFilePath:myURL password:nil];
                if (document != nil)
                {
                    ReaderViewController *readerViewController = [[ReaderViewController alloc]initWithReaderDocument:document];
                    readerViewController.delegate = self;
                        
                    readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                        
                        //[self presentModalViewController:readerViewController animated:YES ];
                        [self presentViewController:readerViewController animated:YES completion:nil];
                    }

            }}];
        }];
    
   // NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
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
