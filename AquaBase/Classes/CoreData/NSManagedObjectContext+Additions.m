//
//  NSManagedObjectContext+Additions.m
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "NSManagedObjectContext+Additions.h"

@implementation NSManagedObjectContext (Additions)

- (id)objectForEntityNamed:(NSString *)entityName matchingKey:(NSString *)aKey value:(id)aValue {
	NSError *err = nil;
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:entityName];
	[req setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", aKey, aValue]];
	NSArray *results = [self executeFetchRequest:req error:&err];
	NSAssert1([results count] < 2, @"There should not be more than one valid result for this request: %@", req.predicate);
	return [results lastObject];
}

@end
