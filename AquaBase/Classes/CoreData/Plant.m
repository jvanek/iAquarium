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
	[result addObjectsFromArray:[NSArray arrayWithObjects:PLANT_KEY_SUBSTSTRACT, PLANT_KEY_LIGHT, PLANT_KEY_PLACEMENT, PLANT_KEY_GROWING_SPEED, nil]];
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

- (BOOL)hasBiotopInformation {
	return [super hasBiotopInformation] || (self.size != nil);
}

- (NSArray *)biotopKeys {
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:3];
	if (self.temperature != nil) [result addObject:LOCALIZED_STRING(@"Temp (°C)")];
	if (self.acidity != nil) [result addObject:LOCALIZED_STRING(@"pH")];
	if (self.hardnessGH != nil) [result addObject:LOCALIZED_STRING(@"GH")];
	if (self.size != nil) [result addObject:LOCALIZED_STRING(@"Size")];
	return result;
}

- (NSDictionary *)biotopValues {
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:3];
	if (self.temperature != nil) [result setObject:self.temperature forKey:LOCALIZED_STRING(@"Temp (°C)")];
	if (self.acidity != nil) [result setObject:self.acidity forKey:LOCALIZED_STRING(@"pH")];
	if (self.hardnessGH != nil) [result setObject:self.hardnessGH forKey:LOCALIZED_STRING(@"GH")];
	if (self.size != nil) [result setObject:self.size forKey:LOCALIZED_STRING(@"Size")];
	return result;
}

- (BOOL)hasDescriptions {
	return [super hasDescriptions] || !(IS_EMPTY_STRING(self.substract) && IS_EMPTY_STRING(self.growingSpeed) &&
										IS_EMPTY_STRING(self.light) && IS_EMPTY_STRING(self.placement));
}

- (NSArray *)descriptionsKeys {
	NSMutableArray *result = [NSMutableArray arrayWithArray:[super descriptionsKeys]];
	if (!IS_EMPTY_STRING(self.substract)) [result addObject:LOCALIZED_STRING(@"Substract")];
	if (!IS_EMPTY_STRING(self.growingSpeed)) [result addObject:LOCALIZED_STRING(@"Growing speed")];
	if (!IS_EMPTY_STRING(self.light)) [result addObject:LOCALIZED_STRING(@"Light")];
	if (!IS_EMPTY_STRING(self.placement)) [result addObject:LOCALIZED_STRING(@"Placement")];
	return result;
}

- (NSDictionary *)descriptionsValues {
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super descriptionsValues]];
	if (!IS_EMPTY_STRING(self.substract)) [result setObject:self.origin forKey:LOCALIZED_STRING(@"Substract")];
	if (!IS_EMPTY_STRING(self.growingSpeed)) [result setObject:self.reproduction forKey:LOCALIZED_STRING(@"Growing speed")];
	if (!IS_EMPTY_STRING(self.light)) [result setObject:self.origin forKey:LOCALIZED_STRING(@"Light")];
	if (!IS_EMPTY_STRING(self.placement)) [result setObject:self.reproduction forKey:LOCALIZED_STRING(@"Placement")];
	return result;
}

@end
