//
//  GenderValuesCell.m
//  AquaBase
//
//  Created by Josef Vanek on 29/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "GenderValuesCell.h"

@interface GenderValuesCell()

- (void)setNumericValue:(NSNumber *)numericValue toLabel:(UILabel *)aLabel;

@end


@implementation GenderValuesCell

@synthesize maleValue, femaleValue, keyTitle;

- (void)setNumericValue:(NSNumber *)numericValue toLabel:(UILabel *)aLabel {
	aLabel.text = (numericValue != nil && numericValue.intValue != 0) ? [NSString stringWithFormat:@"%.1f", numericValue.floatValue] : @"-";
}

- (void)configureWithGenderValues:(GenderValues *)aValues forTitle:(NSString *)aTitle {
	self.keyTitle.text = aTitle;
	[self setNumericValue:aValues.maleValue toLabel:self.maleValue];
	[self setNumericValue:aValues.femaleValue toLabel:self.femaleValue];
}

@end
