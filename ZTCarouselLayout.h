//
//  ZTCarouselLayout.h
//  ECCCarousel
//
//  Created by Zachry Thayer on 10/15/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTCarouselLayout : UICollectionViewFlowLayout <UIScrollViewDelegate>

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat rotation;
@property (nonatomic) CGFloat squareItems;

@end
