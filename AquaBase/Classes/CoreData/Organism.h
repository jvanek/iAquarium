//
//  Organism.h
//  AquaBase
//
//  Created by Vanek Josef on 24/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "GenericManagedObject.h"

#define ORGANISM_ENTITY_NAME		@"Organism"

#define ORGANISM_KEY_SCIENTIFIC_NAME	@"scientificName"
#define ORGANISM_KEY_ORIGIN				@"origin"
#define ORGANISM_KEY_REPRODUCTION		@"reproduction"
#define ORGANISM_KEY_SECTION			@"section"

#define ORGANISM_REL_COMMON_NAMES		@"commonNames"
#define ORGANISM_REL_TEMPERATURE		@"temperature"
#define ORGANISM_REL_ACIDITY			@"acidity"
#define ORGANISM_REL_HARDNESS_GH		@"hardnessGH"
#define ORGANISM_REL_MEDIA				@"media"

@class CommonName, LifeValues, Medium;

@interface Organism : GenericManagedObject

@property (nonatomic, retain) NSString * scientificName;
@property (nonatomic, retain) NSString * section;
@property (nonatomic, retain) NSString * reproduction;
@property (nonatomic, retain) NSString * origin;

@property (nonatomic, retain) LifeValues *acidity;
@property (nonatomic, retain) NSSet *commonNames;
@property (nonatomic, retain) LifeValues *hardnessGH;
@property (nonatomic, retain) LifeValues *temperature;
@property (nonatomic, retain) NSSet *media;

@end

@interface Organism (CoreDataGeneratedAccessors)

- (void)addCommonNamesObject:(CommonName *)value;
- (void)removeCommonNamesObject:(CommonName *)value;
- (void)addCommonNames:(NSSet *)values;
- (void)removeCommonNames:(NSSet *)values;

- (void)addMediaObject:(Medium *)value;
- (void)removeMediaObject:(Medium *)value;
- (void)addMedia:(NSSet *)values;
- (void)removeMedia:(NSSet *)values;

@end
