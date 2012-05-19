//
//  Fish.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "GenericManagedObject.h"

#define FISH_ENTITY_NAME			@"Fish"

#define FISH_KEY_SCIENTIFIC_NAME	@"scientificName"
#define FISH_KEY_COMMENT			@"comment"
#define FISH_KEY_FAMILY				@"family"
#define FISH_KEY_LIFE_DURATION		@"lifeDuration"
#define FISH_KEY_LIFE_ZONE			@"lifeZone"
#define FISH_KEY_ORIGIN				@"origin"
#define FISH_KEY_DIMORPHISM			@"dimorphism"
#define FISH_KEY_BEHAVIOR			@"behavior"
#define FISH_KEY_REPRODUCTION		@"reproduction"
#define FISH_KEY_AUTHOR				@"author"
#define FISH_KEY_SECTION			@"section"

#define FISH_REL_COMMON_NAMES		@"commonNames"
#define FISH_REL_TEMPERATURE		@"temperature"
#define FISH_REL_ACIDITY			@"acidity"
#define FISH_REL_HARDNESS_GH		@"hardnessGH"
#define FISH_REL_SIZE				@"size"
#define FISH_REL_MEDIA				@"media"


@class CommonName;
@class LifeValues;
@class GenderValues;

@interface Fish : GenericManagedObject

@property (nonatomic, retain) NSString * scientificName;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * family;
@property (nonatomic, retain) NSNumber * lifeDuration;
@property (nonatomic, retain) NSString * lifeZone;
@property (nonatomic, retain) NSString * origin;
@property (nonatomic, retain) NSString * dimorphism;
@property (nonatomic, retain) NSString * behavior;
@property (nonatomic, retain) NSString * reproduction;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * section;

@property (nonatomic, retain) NSSet *commonNames;
@property (nonatomic, retain) LifeValues *temperature;
@property (nonatomic, retain) LifeValues *acidity;
@property (nonatomic, retain) LifeValues *hardnessGH;
@property (nonatomic, retain) GenderValues *size;
@property (nonatomic, retain) NSSet *media;

+ (NSArray *)fishUsingPredicate:(NSPredicate *)predicate andOrderings:(NSArray *)orderings inContext:(NSManagedObjectContext *)ctx;

@end

@interface Fish (CoreDataGeneratedAccessors)

- (void)addCommonNamesObject:(CommonName *)value;
- (void)removeCommonNamesObject:(CommonName *)value;
- (void)addCommonNames:(NSSet *)values;
- (void)removeCommonNames:(NSSet *)values;

- (void)addMediaObject:(NSManagedObject *)value;
- (void)removeMediaObject:(NSManagedObject *)value;
- (void)addMedia:(NSSet *)values;
- (void)removeMedia:(NSSet *)values;

@end
