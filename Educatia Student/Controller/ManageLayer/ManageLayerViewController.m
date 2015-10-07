//
//  ManageLayerViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 9/10/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "ManageLayerViewController.h"

@interface ManageLayerViewController ()

@end

@implementation ManageLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)imageViewLayerProfilePicture:(UIImageView*)imageView {
    imageView.layer.borderColor     = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth     = 1.5f;
    imageView.layer.cornerRadius    = 75.0f;
    imageView.layer.masksToBounds   = YES;
}

+ (void)cellLayerSubjectsCollectionView:(UICollectionViewCell*)cell {
    cell.layer.borderColor      = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth      = 0.5f;
    cell.layer.contentsScale    = [UIScreen mainScreen].scale;
    cell.layer.shadowOpacity    = 0.75f;
    cell.layer.shadowRadius     = 5.0f;
    cell.layer.shadowOffset     = CGSizeZero;
    cell.layer.shadowPath       = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
    cell.layer.cornerRadius     = 7.0f;
    cell.layer.masksToBounds    = YES;
}

+ (void)imageViewCellAssignment:(UIImageView*)imageView {
    imageView.layer.borderColor     = [UIColor grayColor].CGColor;
    imageView.layer.borderWidth     = 1.5f;
    imageView.layer.cornerRadius    = 5.0f;
    imageView.layer.masksToBounds   = YES;
}

+ (void)buttonLayerMainView:(UIButton*)button {
    button.layer.borderWidth        = 2.0f;
    button.layer.borderColor        = [UIColor whiteColor].CGColor;
    button.layer.cornerRadius       = 5.0f;
    button.layer.masksToBounds      = YES;
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
