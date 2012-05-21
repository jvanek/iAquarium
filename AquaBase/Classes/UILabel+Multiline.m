//
//  UILabel+Multiline.m
//  BonjourPoc
//
//  Created by Vaněk Josef on 13/04/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "UILabel+Multiline.h"

@implementation UILabel (Multiline)

- (void)adjustForMultilineWithMinimalSize:(CGFloat)minFontSize {
	CGSize virtualSize = CGSizeMake(self.frame.size.width, 480.0);
	CGSize realSize = self.frame.size;
	
	UIFont *currentFont = self.font;
	CGSize computedSize = [self.text sizeWithFont:currentFont constrainedToSize:virtualSize lineBreakMode:self.lineBreakMode];
	while (computedSize.height > realSize.height && currentFont.pointSize > minFontSize) {
		currentFont = [UIFont fontWithName:self.font.familyName size:currentFont.pointSize - 1];
		computedSize = [self.text sizeWithFont:currentFont constrainedToSize:virtualSize lineBreakMode:self.lineBreakMode];
	}
	self.font = currentFont;
}

@end
