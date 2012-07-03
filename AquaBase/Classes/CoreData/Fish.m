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
@dynamic section;

@dynamic commonNames;
@dynamic temperature;
@dynamic acidity;
@dynamic hardnessGH;
@dynamic size;
@dynamic media;

+ (NSArray *)fishUsingPredicate:(NSPredicate *)predicate andOrderings:(NSArray *)orderings inContext:(NSManagedObjectContext *)ctx {
	NSError *err = nil;
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:FISH_ENTITY_NAME];
	[req setPredicate:predicate];
	[req setSortDescriptors:orderings];
	return [ctx executeFetchRequest:req error:&err];
}

+ (NSArray *)attributesToQuery {
	return [NSArray arrayWithObjects:FISH_KEY_AUTHOR, FISH_KEY_BEHAVIOR, FISH_KEY_COMMENT, FISH_KEY_DIMORPHISM, FISH_KEY_FAMILY,
			FISH_KEY_LIFE_ZONE, FISH_KEY_ORIGIN, FISH_KEY_REPRODUCTION, FISH_KEY_SCIENTIFIC_NAME, nil];	
}

- (void)awakeFromInsert {
	[super awakeFromInsert];
	[self updateSectionIndex];
}

- (NSArray *)attributeKeys {
	return [NSArray arrayWithObjects:FISH_KEY_AUTHOR, FISH_KEY_BEHAVIOR, FISH_KEY_COMMENT, FISH_KEY_DIMORPHISM, FISH_KEY_FAMILY,
			FISH_KEY_LIFE_ZONE, FISH_KEY_ORIGIN, FISH_KEY_REPRODUCTION, FISH_KEY_SCIENTIFIC_NAME, nil];
}

- (void)updateSectionIndex {
	self.section = IS_EMPTY_STRING(self.scientificName) ? nil : [[self.scientificName substringToIndex:1] uppercaseString];	
}

- (void)replaceWithDictionary:(NSDictionary *)aDict {
	[super replaceWithDictionary:aDict];

	[self updateSectionIndex];
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

- (BOOL)hasBiotopInformation {
	return self.temperature != nil || self.hardnessGH != nil || self.acidity != nil || self.lifeZone != nil;
}

- (NSUInteger)biotopRowCount {
	return [[self biotopKeys] count];
}

- (NSArray *)biotopKeys {
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:3];
	if (self.temperature != nil) [result addObject:LOCALIZED_STRING(@"Temp (°C)")];
	if (self.acidity != nil) [result addObject:LOCALIZED_STRING(@"pH")];
	if (self.hardnessGH != nil) [result addObject:LOCALIZED_STRING(@"GH")];
	return result;	
}

- (NSDictionary *)biotopValues {
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:3];
	if (self.temperature != nil) [result setObject:self.temperature forKey:LOCALIZED_STRING(@"Temp (°C)")];
	if (self.acidity != nil) [result setObject:self.acidity forKey:LOCALIZED_STRING(@"pH")];
	if (self.hardnessGH != nil) [result setObject:self.hardnessGH forKey:LOCALIZED_STRING(@"GH")];
	return result;
}

- (BOOL)hasFactsInformation {
	return self.lifeDuration != nil || self.lifeZone != nil || self.author != nil;
}

- (NSUInteger)factsRowCount {
	return [[self factsKeys] count];
}

- (NSArray *)factsKeys {
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:3];
	if (self.lifeDuration != nil && self.lifeDuration.intValue != 0) [result addObject:LOCALIZED_STRING(@"Life duration")];
	if (self.lifeZone != nil) [result addObject:LOCALIZED_STRING(@"Life zone")];
	if (self.author != nil) [result addObject:LOCALIZED_STRING(@"Author")];
	return result;	
}

- (NSDictionary *)factsValues {
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:3];
	if (self.lifeDuration != nil && self.lifeDuration.intValue != 0) [result setObject:[NSString stringWithFormat:@"%d", self.lifeDuration.intValue] forKey:LOCALIZED_STRING(@"Life duration")];
	if (self.lifeZone != nil) [result setObject:self.lifeZone forKey:LOCALIZED_STRING(@"Life zone")];
	if (self.author != nil) [result setObject:self.author forKey:LOCALIZED_STRING(@"Author")];
	return result;	
}

- (BOOL)hasDescriptions {
	return !(IS_EMPTY_STRING(self.origin) && IS_EMPTY_STRING(self.comment) && IS_EMPTY_STRING(self.dimorphism) &&
			 IS_EMPTY_STRING(self.behavior) && IS_EMPTY_STRING(self.reproduction));
}

- (NSUInteger)descriptionsRowCount {
	return [[self descriptionsKeys] count];
}

- (NSArray *)descriptionsKeys {
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:5];
	if (!IS_EMPTY_STRING(self.origin)) [result addObject:LOCALIZED_STRING(@"Origin")];
	if (!IS_EMPTY_STRING(self.comment)) [result addObject:LOCALIZED_STRING(@"Description")];
	if (!IS_EMPTY_STRING(self.dimorphism)) [result addObject:LOCALIZED_STRING(@"Dimorphism")];
	if (!IS_EMPTY_STRING(self.behavior)) [result addObject:LOCALIZED_STRING(@"Behavior")];
	if (!IS_EMPTY_STRING(self.reproduction)) [result addObject:LOCALIZED_STRING(@"Reproduction")];
	return result;	
}

- (NSDictionary *)descriptionsValues {
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:5];
	if (!IS_EMPTY_STRING(self.origin)) [result setObject:self.origin forKey:LOCALIZED_STRING(@"Origin")];
	if (!IS_EMPTY_STRING(self.comment)) [result setObject:self.comment forKey:LOCALIZED_STRING(@"Description")];
	if (!IS_EMPTY_STRING(self.dimorphism)) [result setObject:self.dimorphism forKey:LOCALIZED_STRING(@"Dimorphism")];
	if (!IS_EMPTY_STRING(self.behavior)) [result setObject:self.behavior forKey:LOCALIZED_STRING(@"Behavior")];
	if (!IS_EMPTY_STRING(self.reproduction)) [result setObject:self.reproduction forKey:LOCALIZED_STRING(@"Reproduction")];
	return result;	
}

@end
