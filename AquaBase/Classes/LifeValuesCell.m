//
//  LifeValuesCell.m
//  AquaBase
//
//  Created by Vaněk Josef on 21/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "LifeValuesCell.h"

@interface LifeValuesCell()

- (void)setNumericValue:(NSNumber *)numericValue toLabel:(UILabel *)aLabel;

@end


@implementation LifeValuesCell

@synthesize minValue, maxValue, reproValue, keyTitle;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setNumericValue:(NSNumber *)numericValue toLabel:(UILabel *)aLabel {
	aLabel.text = (numericValue != nil && numericValue.intValue != 0) ? [NSString stringWithFormat:@"%.1f", numericValue.floatValue] : @"-";
}

- (void)configureWithLifeValues:(LifeValues *)aValues forTitle:(NSString *)aTitle {
	self.keyTitle.text = aTitle;
	[self setNumericValue:aValues.valueMin toLabel:self.minValue];
	[self setNumericValue:aValues.valueMax toLabel:self.maxValue];
	[self setNumericValue:aValues.valueRepro toLabel:self.reproValue];
}

@end
