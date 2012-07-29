//
//  Organism.m
//  AquaBase
//
//  Created by Vanek Josef on 24/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "Organism.h"
#import "CommonName.h"
#import "LifeValues.h"
#import "Medium.h"
#import "StreamKeys.h"


@implementation Organism

@dynamic scientificName;
@dynamic section;
@dynamic reproduction;
@dynamic origin;
@dynamic acidity;
@dynamic commonNames;
@dynamic hardnessGH;
@dynamic temperature;
@dynamic media;

- (void)awakeFromInsert {
	[super awakeFromInsert];
	[self updateSectionIndex];
}

- (NSArray *)attributeKeys {
	return [NSArray arrayWithObjects:ORGANISM_KEY_ORIGIN, ORGANISM_KEY_SCIENTIFIC_NAME, ORGANISM_KEY_REPRODUCTION, nil];
}

- (void)updateSectionIndex {
	if (IS_EMPTY_STRING(self.scientificName)) self.scientificName = @"Undefined";
	self.section = [[self.scientificName substringToIndex:1] uppercaseString];
}

- (void)replaceWithDictionary:(NSDictionary *)aDict {
	[super replaceWithDictionary:aDict];
	[self updateSectionIndex];
	
	NSArray *names = [aDict objectForKey:STREAM_KEY_NOM_COMMUNS];
	for (CommonName *cName in self.commonNames) [self.managedObjectContext deleteObject:cName];
	for (NSString *aName in names) {
		CommonName *cName = [NSEntityDescription insertNewObjectForEntityForName:COMMON_NAME_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
		cName.label = aName;
		[self addCommonNamesObject:cName];
	}	
}

- (BOOL)hasBiotopInformation {
	return self.temperature != nil || self.hardnessGH != nil || self.acidity != nil;
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
	return NO;
}

- (NSUInteger)factsRowCount {
	return 0;
}

- (NSArray *)factsKeys {
	return nil;
}

- (NSDictionary *)factsValues {
	return nil;
}

- (BOOL)hasDescriptions {
	return !(IS_EMPTY_STRING(self.origin) && IS_EMPTY_STRING(self.reproduction));
}

- (NSUInteger)descriptionsRowCount {
	return [[self descriptionsKeys] count];
}

- (NSArray *)descriptionsKeys {
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:5];
	if (!IS_EMPTY_STRING(self.origin)) [result addObject:LOCALIZED_STRING(@"Origin")];
	if (!IS_EMPTY_STRING(self.reproduction)) [result addObject:LOCALIZED_STRING(@"Reproduction")];
	return result;
}

- (NSDictionary *)descriptionsValues {
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:5];
	if (!IS_EMPTY_STRING(self.origin)) [result setObject:self.origin forKey:LOCALIZED_STRING(@"Origin")];
	if (!IS_EMPTY_STRING(self.reproduction)) [result setObject:self.reproduction forKey:LOCALIZED_STRING(@"Reproduction")];
	return result;
}

@end
