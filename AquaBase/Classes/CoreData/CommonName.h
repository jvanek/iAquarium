//
//  CommonName.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "GenericManagedObject.h"

#define COMMON_NAME_ENTITY_NAME			@"CommonName"

#define COMMON_NAME_KEY_LABEL			@"label"

#define COMMON_NAME_REL_LOCALIZATION	@"localization"
#define COMMON_NAME_REL_FISH			@"fish"

@class Localization;
@class Fish;


@interface CommonName : GenericManagedObject

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) Localization *localization;
@property (nonatomic, retain) Fish *fish;

@end
