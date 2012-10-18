//
//  ZTTestCell.m
//  ECCCarousel
//
//  Created by Zachry Thayer on 10/15/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTTestCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ZTTestCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
//        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
//        self.layer.shadowPath = [shadowPath CGPath];
//        self.layer.shadowOffset = CGSizeMake(0, 0);
//        self.layer.shadowOpacity = 0.5f;
//        self.layer.shadowColor = [[UIColor colorWithWhite:0 alpha:1] CGColor];
        
        self.layer.borderWidth = 2.f;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
//
//        self.clipsToBounds = NO;
//        self.layer.masksToBounds = NO;
        
    }
    return self;
}

@end
