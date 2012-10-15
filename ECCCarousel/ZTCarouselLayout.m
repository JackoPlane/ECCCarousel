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
        _scrollPadding = 3.f;
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
    perspectiveTransform = CATransform3DRotate(perspectiveTransform, _rotation, 0, 0, 1.f);
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
    // 0 rotation means the focused item will be at 1.0 on the x axis and 0.0 on z axis, however we want to look at -1.0 z and 0.0 x, so lets offset our radians by this quarter of a circle
    CGFloat rotationOffset = TAU / 4;
    _scrollOffset = (self.collectionView.contentOffset.x)/(self.collectionView.contentSize.width - self.collectionView.bounds.size.width) * _scrollPadding;
    
    CGFloat radians = (indexPath.row * step) + rotationOffset + (_scrollOffset * TAU);
    
    radians = radians;//invert order
    
    CGFloat x = _carouselOffset.width + _radius * cosf(radians);
    CGFloat z = -_radius + _radius * sinf(radians);
    
    CATransform3D transform = CATransform3DMakeTranslation(x + self.collectionView.contentOffset.x, _carouselOffset.height, z);
    
    if (_squareItems)
    {
        transform = CATransform3DRotate(transform, -_rotation, 0, 0, 1.f);
    }
    
    attributes.transform3D = transform;
    attributes.size = CGSizeMake(250, 150);
    
    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat scrollWidth = self.collectionView.contentSize.width - self.collectionView.bounds.size.width;
    CGFloat proposedOffset = proposedContentOffset.x/scrollWidth;
    NSInteger itemIndex = proposedOffset * _cellCount;
    //itemIndex += velocity.x / 200.f;
    
    return CGPointMake(scrollWidth/_cellCount * itemIndex, 0);
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
    scrollView.contentOffset = CGPointMake(centerX,0);
    _scrollOffset -= (scrollView.contentOffset.x)/(scrollView.contentSize.width - scrollView.bounds.size.width) * _scrollPadding;
}

@end
