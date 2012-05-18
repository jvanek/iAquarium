//
//  Fish.m
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "Fish.h"
#import "CommonName.h"
#import "StreamKeys.h"
#import "LifeValues.h"
#import "GenderValues.h"


@implementation Fish

@dynamic scientificName;
@dynamic comment;
@dynamic family;
@dynamic lifeDuration;
@dynamic lifeZone;
@dynamic origin;
@dynamic dimorphism;
@dynamic behavior;
@dynamic reproduction;
@dynamic author;

@dynamic commonNames;
@dynamic temperature;
@dynamic acidity;
@dynamic hardnessGH;
@dynamic size;
@dynamic media;

- (NSArray *)attributeKeys {
	return [NSArray arrayWithObjects:FISH_KEY_AUTHOR, FISH_KEY_BEHAVIOR, FISH_KEY_COMMENT, FISH_KEY_DIMORPHISM, FISH_KEY_FAMILY,
			FISH_KEY_LIFE_ZONE, FISH_KEY_ORIGIN, FISH_KEY_REPRODUCTION, FISH_KEY_SCIENTIFIC_NAME, nil];
}

- (void)replaceWithDictionary:(NSDictionary *)aDict {
	[super replaceWithDictionary:aDict];

	self.lifeDuration = [self floatValueFromObject:[aDict objectForKey:[self mappedKeyForKey:FISH_KEY_LIFE_DURATION]]];

	NSArray *names = [aDict objectForKey:STREAM_KEY_NOM_COMMUNS];
	for (CommonName *cName in self.commonNames) [self.managedObjectContext deleteObject:cName];
	for (NSString *aName in names) {
		CommonName *cName = [NSEntityDescription insertNewObjectForEntityForName:COMMON_NAME_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
		cName.label = aName;
		[self addCommonNamesObject:cName];
	}
	
	if (!(IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_PHMAX]) &&
		  IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_PHMIN]) &&
		  IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_PHREPRO]))) {
		if (self.acidity == nil)
			self.acidity = [NSEntityDescription insertNewObjectForEntityForName:LIFE_VALUES_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
		self.acidity.valueMin = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_PHMIN]];
		self.acidity.valueMax = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_PHMAX]];
		self.acidity.valueRepro = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_PHREPRO]];
	} else [self.managedObjectContext deleteObject:self.acidity];

	if (!(IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_GHMIN]) &&
		  IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_GHMAX]) &&
		  IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_GHREPRO]))) {
		if (self.hardnessGH == nil)
			self.hardnessGH = [NSEntityDescription insertNewObjectForEntityForName:LIFE_VALUES_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
		self.hardnessGH.valueMin = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_GHMIN]];
		self.hardnessGH.valueMax = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_GHMAX]];
		self.hardnessGH.valueRepro = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_GHREPRO]];
	} else [self.managedObjectContext deleteObject:self.hardnessGH];

	if (!(IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_TEMP_MIN]) &&
		  IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_TEMP_MAX]) &&
		  IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_TEMP_REPRO]))) {
		if (self.temperature == nil)
			self.temperature = [NSEntityDescription insertNewObjectForEntityForName:LIFE_VALUES_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
		self.temperature.valueMin = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_TEMP_MIN]];
		self.temperature.valueMax = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_TEMP_MAX]];
		self.temperature.valueRepro = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_TEMP_REPRO]];
	} else [self.managedObjectContext deleteObject:self.temperature];

	if (!(IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_TAILLE_MALE]) &&
		  IS_EMPTY_STRING([aDict objectForKey:STREAM_KEY_TAILLE_FEMELLE]))) {
		if (self.size == nil)
			self.size = [NSEntityDescription insertNewObjectForEntityForName:GENDER_VALUES_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
		self.size.maleValue = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_TAILLE_MALE]];
		self.size.femaleValue = [self floatValueFromObject:[aDict objectForKey:STREAM_KEY_TAILLE_FEMELLE]];
	} else [self.managedObjectContext deleteObject:self.size];
}

@end
