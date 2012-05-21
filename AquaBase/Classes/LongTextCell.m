//
//  LongTextCell.m
//  AquaBase
//
//  Created by Vaněk Josef on 21/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "LongTextCell.h"
#import "UILabel+Multiline.h"


@implementation LongTextCell

@synthesize titleLabel, textLabel;


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureWithTitle:(NSString *)aTitle andText:(NSString *)aText {
	self.titleLabel.text = aTitle;
	self.textLabel.text = aText;
	[self.textLabel adjustForMultilineWithMinimalSize:9.0];
}

@end
