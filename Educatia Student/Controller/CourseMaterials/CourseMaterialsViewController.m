//
//  CourseMaterialsViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "CourseMaterialsViewController.h"
#import <Parse/Parse.h>
#import "ThumbnailPDF.h"

@interface CourseMaterialsViewController ()

@end

@implementation CourseMaterialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadAndStorePDFFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickOpenPDF:(id)sender{
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:_filePath password:nil];
    if (document != nil)
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc]initWithReaderDocument:document];
        readerViewController.delegate = self;
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        //[self presentModalViewController:readerViewController animated:YES ];
        [self presentViewController:readerViewController animated:YES completion:nil];
    }

    // NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
}

- (void)loadAndStorePDFFile {
    [self showPlayLoadActivity];
    PFQuery *query = [PFQuery queryWithClassName:@"CourseMaterials"];
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
        [self stopHideLoadingActivity];
    }];
}
- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - loadingPDFActivityIndicator behaviour

- (void)stopHideLoadingActivity {
    [self.loadingPDfActivityIndicator stopAnimating];
    self.loadingPDfActivityIndicator.hidden = YES;
}

- (void)showPlayLoadActivity {
    [self.loadingPDfActivityIndicator startAnimating ];
    self.loadingPDfActivityIndicator.hidden = NO;
}

@end
