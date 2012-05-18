//
//  LifeValues.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "GenericManagedObject.h"

#define LIFE_VALUES_ENTITY_NAME			@"LifeValues"

#define LIFE_VALUES_KEY_VALUEMIN		@"valueMin"
#define LIFE_VALUES_KEY_VALUEMAX		@"valueMax"
#define LIFE_VALUES_KEY_VALUEREPRO		@"valueRepro"

#define LIFE_VALUES_REL_TEMPERATURE		@"fishTemp"
#define LIFE_VALUES_REL_ACIDITY			@"fishAcid"
#define LIFE_VALUES_REL_HARDNESS_GH		@"fishHardnessGH"


@class Fish;

@interface LifeValues : GenericManagedObject

@property (nonatomic, retain) NSNumber * valueMin;
@property (nonatomic, retain) NSNumber * valueMax;
@property (nonatomic, retain) NSNumber * valueRepro;
@property (nonatomic, retain) NSSet *fishTemp;
@property (nonatomic, retain) NSSet *fishAcid;
@property (nonatomic, retain) NSSet *fishHardnessGH;

@end

@interface LifeValues (CoreDataGeneratedAccessors)

- (void)addFishTempObject:(Fish *)value;
- (void)removeFishTempObject:(Fish *)value;
- (void)addFishTemp:(NSSet *)values;
- (void)removeFishTemp:(NSSet *)values;

- (void)addFishAcidObject:(Fish *)value;
- (void)removeFishAcidObject:(Fish *)value;
- (void)addFishAcid:(NSSet *)values;
- (void)removeFishAcid:(NSSet *)values;

- (void)addFishHardnessGHObject:(Fish *)value;
- (void)removeFishHardnessGHObject:(Fish *)value;
- (void)addFishHardnessGH:(NSSet *)values;
- (void)removeFishHardnessGH:(NSSet *)values;

@end
