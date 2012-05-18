//
//  SearchCriterium.m
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "SearchCriterium.h"

@implementation SearchCriterium

@synthesize title, predicate;

- (void)dealloc {
	self.title = nil;
	self.predicate = nil;
}

+ (SearchCriterium *)searchCriterium {
	return [SearchCriterium searchCriteriumWithTitle:nil andPredicate:nil];
}

+ (SearchCriterium *)searchCriteriumWithTitle:(NSString *)aTitle {
	return [SearchCriterium searchCriteriumWithTitle:aTitle andPredicate:nil];
}

+ (SearchCriterium *)searchCriteriumWithTitle:(NSString *)aTitle andPredicate:(NSComparisonPredicate *)aPredicate {
	SearchCriterium *result = [[SearchCriterium alloc] init];
	result.title = aTitle;
	result.predicate = aPredicate;
	return result;	
}

/*
 [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@""]
 rightExpression:[NSExpression expressionForEvaluatedObject]
 modifier:NSDirectPredicateModifier
 type:NSEqualToPredicateOperatorType
 options:NSCaseInsensitivePredicateOption | NSDiacriticInsensitivePredicateOption]];
 */

@end
