//
//  SubjectsViewController.m
//  Educatia Student
//
//  Created by Tamer Alaa on 8/21/15.
//  Copyright (c) 2015 Bluewave Solutions. All rights reserved.
//

#import "SubjectsViewController.h"

@implementation SubjectsViewController


-(void)viewDidLoad{

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BasicCell" forIndexPath:indexPath];
    
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{



}
@end
