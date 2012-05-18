//
//  GenderValues.m
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "GenderValues.h"
#import "Fish.h"


@implementation GenderValues

@dynamic maleValue;
@dynamic femaleValue;
@dynamic fish;

- (NSArray *)attributeKeys {
	return [NSArray arrayWithObjects:GENDER_VALUES_KEY_FEMALE_VALUE, GENDER_VALUES_KEY_MALE_VALUE, nil];
}

@end
