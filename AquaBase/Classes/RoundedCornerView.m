//
//  RoundedCornerView.m
//  BusinessTalk
//
//  Created by Vaněk Josef on 27/03/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "RoundedCornerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedCornerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
	CALayer *layer = [self layer];
	
    // clear the view's background color so that our background
    // fits within the rounded border
    CGColorRef backgroundColor = [self.backgroundColor CGColor];
    self.backgroundColor = [UIColor clearColor];
    layer.backgroundColor = backgroundColor;
    layer.cornerRadius = 15.0f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
