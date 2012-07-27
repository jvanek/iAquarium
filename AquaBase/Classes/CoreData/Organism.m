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

@end
