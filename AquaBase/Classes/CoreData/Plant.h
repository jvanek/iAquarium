//
//  Plant.h
//  AquaBase
//
//  Created by Vanek Josef on 24/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "Organism.h"

#define PLANT_ENTITY_NAME		@"Plant"

#define PLANT_KEY_SUBSTSTRACT	@"substract"
#define PLANT_KEY_GROWING_SPEED	@"growingSpeed"
#define PLANT_KEY_LIGHT			@"light"
#define PLANT_KEY_PLACEMENT		@"placement"

#define PLANT_REL_SIZE			@"size"

@class LifeValues;

@interface Plant : Organism

@property (nonatomic, retain) NSString * substract;
@property (nonatomic, retain) NSString * growingSpeed;
@property (nonatomic, retain) NSString * light;
@property (nonatomic, retain) NSString * placement;

@property (nonatomic, retain) LifeValues *size;

@end
