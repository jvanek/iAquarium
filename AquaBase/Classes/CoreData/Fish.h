//
//  Fish.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "Organism.h"

#define FISH_ENTITY_NAME			@"Fish"

#define FISH_KEY_COMMENT			@"comment"
#define FISH_KEY_FAMILY				@"family"
#define FISH_KEY_LIFE_DURATION		@"lifeDuration"
#define FISH_KEY_LIFE_ZONE			@"lifeZone"
#define FISH_KEY_DIMORPHISM			@"dimorphism"
#define FISH_KEY_BEHAVIOR			@"behavior"
#define FISH_KEY_REPRODUCTION		@"reproduction"
#define FISH_KEY_AUTHOR				@"author"

#define FISH_REL_SIZE				@"size"


@class CommonName;
@class LifeValues;
@class GenderValues;

@interface Fish : Organism

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * family;
@property (nonatomic, retain) NSNumber * lifeDuration;
@property (nonatomic, retain) NSString * lifeZone;
@property (nonatomic, retain) NSString * dimorphism;
@property (nonatomic, retain) NSString * behavior;
@property (nonatomic, retain) NSString * author;

@property (nonatomic, retain) GenderValues *size;

+ (NSArray *)fishUsingPredicate:(NSPredicate *)predicate andOrderings:(NSArray *)orderings inContext:(NSManagedObjectContext *)ctx;
+ (NSArray *)attributesToQuery;

- (BOOL)hasBiotopInformation;
- (NSUInteger)biotopRowCount;
- (NSArray *)biotopKeys;
- (NSDictionary *)biotopValues;

- (BOOL)hasFactsInformation;
- (NSUInteger)factsRowCount;
- (NSArray *)factsKeys;
- (NSDictionary *)factsValues;

- (BOOL)hasDescriptions;
- (NSUInteger)descriptionsRowCount;
- (NSArray *)descriptionsKeys;
- (NSDictionary *)descriptionsValues;

- (void)updateSectionIndex;

@end
