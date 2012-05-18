//
//  GenderValues.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "GenericManagedObject.h"

#define GENDER_VALUES_ENTITY_NAME			@"GenderValues"

#define FISH_KEY_MALE_VALUE		@"maleValue"
#define FISH_KEY_FEMALE_VALUE	@"femaleValue"

#define FISH_REL_FISH			@"fish"

@class Fish;

@interface GenderValues : GenericManagedObject

@property (nonatomic, retain) NSNumber * maleValue;
@property (nonatomic, retain) NSNumber * femaleValue;
@property (nonatomic, retain) NSSet *fish;
@end

@interface GenderValues (CoreDataGeneratedAccessors)

- (void)addFishObject:(Fish *)value;
- (void)removeFishObject:(Fish *)value;
- (void)addFish:(NSSet *)values;
- (void)removeFish:(NSSet *)values;

@end
