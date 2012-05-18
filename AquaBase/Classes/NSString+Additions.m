//
//  NSString+Additions.m
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSString *)trim {
	NSCharacterSet *trimSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n"];
	return [self stringByTrimmingCharactersInSet:trimSet];
}

@end
