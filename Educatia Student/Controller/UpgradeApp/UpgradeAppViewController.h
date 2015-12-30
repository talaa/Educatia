//
//  UpgradeAppViewController.h
//  Educatia Student
//
//  Created by Mena Bebawy on 12/30/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface UpgradeAppViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *upgradeButton;
@property (strong, nonatomic) SKProduct *product;

@end
