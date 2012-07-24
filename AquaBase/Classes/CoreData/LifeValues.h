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

#define LIFE_VALUES_REL_TEMPERATURE		@"organismTemp"
#define LIFE_VALUES_REL_ACIDITY			@"organismAcid"
#define LIFE_VALUES_REL_HARDNESS_GH		@"orgnaismHardnessGH"
#define LIFE_VALUES_REL_PLANTS			@"plants"


@class Organism;
@class Plant;


@interface LifeValues : GenericManagedObject

@property (nonatomic, retain) NSNumber * valueMin;
@property (nonatomic, retain) NSNumber * valueMax;
@property (nonatomic, retain) NSNumber * valueRepro;

@property (nonatomic, retain) NSSet *organismTemp;
@property (nonatomic, retain) NSSet *organismAcid;
@property (nonatomic, retain) NSSet *organismHardnessGH;
@property (nonatomic, retain) NSSet *plants;

@end

@interface LifeValues (CoreDataGeneratedAccessors)

- (void)addOrganismTempObject:(Organism *)value;
- (void)removeOrganismTempObject:(Organism *)value;
- (void)addOrganismTemp:(NSSet *)values;
- (void)removeOrganismTemp:(NSSet *)values;

- (void)addOrganismAcidObject:(Organism *)value;
- (void)removeOrganismAcidObject:(Organism *)value;
- (void)addOrganismAcid:(NSSet *)values;
- (void)removeOrganismAcid:(NSSet *)values;

- (void)addOrganismHardnessGHObject:(Organism *)value;
- (void)removeOrganismHardnessGHObject:(Organism *)value;
- (void)addOrganismHardnessGH:(NSSet *)values;
- (void)removeOrganismHardnessGH:(NSSet *)values;

- (void)addPlantObject:(Plant *)value;
- (void)removePlantObject:(Plant *)value;
- (void)addPlant:(NSSet *)values;
- (void)removePlant:(NSSet *)values;

@end
