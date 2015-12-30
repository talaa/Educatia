//
//  UpgradeAppViewController.m
//  Educatia Student
//
//  Created by Mena Bebawy on 12/30/15.
//  Copyright © 2015 Bluewave Solutions. All rights reserved.
//

#import "UpgradeAppViewController.h"
#define kInAppPurchaseProUpgradeProductId @"com.BWS.EducatiaStudent.oneMonth"

@interface UpgradeAppViewController () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation UpgradeAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


/***********************************/
#pragma mark - InApp Purchase   
/**********************************/

- (IBAction)purchase:(id)sender{
    SKProductsRequest *request= [[SKProductsRequest alloc]
                                 initWithProductIdentifiers: [NSSet setWithObject: @"com.BWS.EducatiaStudent.oneMonth"]];
    request.delegate = self;
    [request start];

}

- (void)buyProductIdentifier:(NSString *)productIdentifier
{
    SKMutablePayment *payment = [[SKMutablePayment alloc] init] ;
    payment.productIdentifier = productIdentifier;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *selectedProduct = response.products[0];
    [self buyProductIdentifier:selectedProduct.productIdentifier];
}

@end
