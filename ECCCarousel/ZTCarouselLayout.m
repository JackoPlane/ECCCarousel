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
    NSInteger _cellCount;
    CGSize _carouselOffset;
}

@end

@implementation ZTCarouselLayout

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _rotation = -TAU/8.f;
        _squareItem = YES;
        
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    CATransform3D perspectiveTransform = CATransform3DIdentity;
    perspectiveTransform.m34 = -1.f/500.f;
    if (_squareItem)
    {
     perspectiveTransform = CATransform3DRotate(perspectiveTransform, _rotation, 0, 0, 1.f);
    }
    self.collectionView.layer.sublayerTransform = perspectiveTransform;
    
    _cellCount = [self.collectionView numberOfItemsInSection:0];

    _carouselOffset = CGSizeMake(self.collectionView.frame.size.width/2.f, self.collectionView.frame.size.height/2.f);
    
    _radius = 300.f;
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.showsHorizontalScrollIndicator = NO;

}

- (CGSize)collectionViewContentSize
{
    CGSize contentSize = self.collectionView.frame.size;
    contentSize.width = _cellCount * 250;
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
    CGFloat scrollOffset = self.collectionView.contentOffset.x/self.collectionView.contentSize.width;
    
    CGFloat radians = (indexPath.row * step) + rotationOffset + (scrollOffset * TAU);
    
    radians = radians;//invert order
    
    CGFloat x = _carouselOffset.width + _radius * cosf(radians);
    CGFloat z = -_radius + _radius * sinf(radians);
    
    CATransform3D transform = CATransform3DMakeTranslation(x + self.collectionView.contentOffset.x, _carouselOffset.height, z);
    
    if (_squareItem)
    {
        transform = CATransform3DRotate(transform, -_rotation, 0, 0, 1.f);
    }
    
    attributes.transform3D = transform;
    attributes.size = CGSizeMake(250, 150);
    
    return attributes;
}

//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    
//}

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


@end
