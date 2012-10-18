//
//  ZTCollectionVC.m
//  ECCCarousel
//
//  Created by Zachry Thayer on 10/15/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTCarouselVC.h"
#import "ZTTestCell.h"
#import "ZTCarouselLayout.h"

@interface ZTCarouselVC ()

@end

@implementation ZTCarouselVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    //Center on load
    CGFloat centerX = (self.collectionView.contentSize.width - self.collectionView.bounds.size.width)/2.f;
    self.collectionView.contentOffset = CGPointMake(centerX,0);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZTTestCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TestCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.TitleLabel.text = [NSString stringWithFormat:@"Card #%i", indexPath.item];
    return cell;
}

/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(250, 150);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

#pragma UIScrollDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    ZTCarouselLayout *layoutEngine = (ZTCarouselLayout *)self.collectionView.collectionViewLayout;
    [layoutEngine scrollViewDidEndDecelerating:scrollView];
}

@end
