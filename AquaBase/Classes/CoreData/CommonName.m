//
//  CommonName.m
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "CommonName.h"


@implementation CommonName

@dynamic label;
@dynamic localization;
@dynamic fish;

- (NSArray *)attributeKeys {
	return [NSArray arrayWithObjects:COMMON_NAME_KEY_LABEL, nil];
}

@end
