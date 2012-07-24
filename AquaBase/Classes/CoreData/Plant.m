//
//  Plant.m
//  AquaBase
//
//  Created by Vanek Josef on 24/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "Plant.h"
#import "StreamKeys.h"
#import "LifeValues.h"


@implementation Plant

@dynamic substract;
@dynamic growingSpeed;
@dynamic light;
@dynamic placement;
@dynamic size;

- (NSArray *)attributeKeys {
	NSMutableArray *result = [NSMutableArray arrayWithArray:[super attributeKeys]];
	[result addObjectsFromArray:[NSArray arrayWithObjects:nil]];
	return result;
}

- (void)replaceWithDictionary:(NSDictionary *)aDict {
	[super replaceWithDictionary:aDict];

	if (!(IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_PHMAX]) &&
		  IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_PHMIN]))) {
		if (self.acidity == nil)
			self.acidity = [NSEntityDescription insertNewObjectForEntityForName:LIFE_VALUES_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
		self.acidity.valueMin = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_PHMIN]];
		self.acidity.valueMax = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_PHMAX]];
	} else [self.managedObjectContext deleteObject:self.acidity];
	
	if (!(IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_GHMIN]) &&
		  IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_GHMAX]))) {
		if (self.hardnessGH == nil)
			self.hardnessGH = [NSEntityDescription insertNewObjectForEntityForName:LIFE_VALUES_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
		self.hardnessGH.valueMin = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_GHMIN]];
		self.hardnessGH.valueMax = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_GHMAX]];
	} else [self.managedObjectContext deleteObject:self.hardnessGH];
	
	if (!(IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_TEMP_MIN]) &&
		  IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_TEMP_MAX]))) {
		if (self.temperature == nil)
			self.temperature = [NSEntityDescription insertNewObjectForEntityForName:LIFE_VALUES_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
		self.temperature.valueMin = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_TEMP_MIN]];
		self.temperature.valueMax = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_TEMP_MAX]];
	} else [self.managedObjectContext deleteObject:self.temperature];
	
	if (!(IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_TAILLE_MIN]) &&
		  IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_TAILLE_MAX]))) {
		if (self.size == nil)
			self.size = [NSEntityDescription insertNewObjectForEntityForName:LIFE_VALUES_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
		self.size.valueMin = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_TAILLE_MIN]];
		self.size.valueMax = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_TAILLE_MAX]];
	} else [self.managedObjectContext deleteObject:self.size];
}

@end
