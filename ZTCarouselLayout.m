//
//  ZTCarouselLayout.m
//  ECCCarousel
//
//  Created by Zachry Thayer on 10/15/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTCarouselLayout.h"

#import <QuartzCore/QuartzCore.h>


#define TAU M_PI*2.f

@interface ZTCarouselLayout ()
{
    CGFloat _scrollPadding;
    NSInteger _cellCount;
    CGSize _carouselOffset;
    CGFloat _rotationOffset;
    CGFloat _scrollOffset;
}

@end

@implementation ZTCarouselLayout

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _scrollPadding = 1.f;//Huge virtual scrolling limit (for people with scroll OCD)
        _rotation = -TAU/8.f;
        _squareItems = YES;
        
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    CATransform3D perspectiveTransform = CATransform3DIdentity;
    perspectiveTransform.m34 = -1.f/500.f;
    //perspectiveTransform = CATransform3DRotate(perspectiveTransform, _rotation, 0, 0, 1.f);
    self.collectionView.layer.sublayerTransform = perspectiveTransform;
    
    _cellCount = [self.collectionView numberOfItemsInSection:0];

    _carouselOffset = CGSizeMake(self.collectionView.frame.size.width/2.f, self.collectionView.frame.size.height/2.f);
    
    _radius = 300.f;
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
   // self.collectionView.showsHorizontalScrollIndicator = NO;

}

- (CGSize)collectionViewContentSize
{
    CGSize contentSize = self.collectionView.frame.size;
    contentSize.width = _cellCount * 250 * _scrollPadding;
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
    CGFloat step = TAU / _cellCount;
    CGFloat rotationOffset = TAU / 4;
    _scrollOffset = (self.collectionView.contentOffset.x)/(self.collectionView.contentSize.width - self.collectionView.bounds.size.width) * _scrollPadding;
   // _scrollPadding += _rotationOffset;
    
    while (_scrollOffset > TAU)
    {
        _scrollOffset -= TAU;
    }
    while (_scrollOffset < -TAU)
    {
        _scrollOffset += TAU;
    }
    
    CGFloat radians = ((_cellCount - indexPath.row) * step) + rotationOffset + (_scrollOffset * TAU);
        
    CGFloat x = _carouselOffset.width + _radius * cosf(radians);
    CGFloat z = -_radius + _radius * sinf(radians);
    
    CATransform3D transform = CATransform3DMakeTranslation(x + self.collectionView.contentOffset.x, _carouselOffset.height, z);
    
    if (_squareItems)
    {
      //  transform = CATransform3DRotate(transform, -_rotation, 0, 0, 1.f);
    }
    
    attributes.transform3D = transform;
    attributes.size = CGSizeMake(250, 150);
    
    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat baseContentSize = self.collectionView.contentSize.width/_scrollPadding;
    CGFloat step = (baseContentSize - self.collectionView.bounds.size.width) / _cellCount;
    NSInteger index = ceilf((proposedContentOffset.x/_scrollPadding) / step);
    
    NSInteger baseIndex = proposedContentOffset.x / (baseContentSize - self.collectionView.bounds.size.width);
    CGFloat baseOffset = baseIndex * (baseContentSize);
    
    CGFloat contentX = baseOffset + (index * step);
    
    return CGPointMake(contentX, 0);
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{    
    NSMutableArray *attributes = [NSMutableArray array];
    for (int i = 0; i < _cellCount; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    return attributes;
}

#pragma UIScrollDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //Center offset after scroll
    
    CGFloat centerX = (scrollView.contentSize.width - scrollView.bounds.size.width)/2.f;
    _rotationOffset = _scrollOffset - centerX;
    
    while (_rotationOffset > TAU)
    {
        _rotationOffset -= TAU;
    }
    while (_rotationOffset < 0)
    {
        _rotationOffset += TAU;
    }
    
 //   scrollView.contentOffset = CGPointMake(centerX,0);
    
    
}

@end
