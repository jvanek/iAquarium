//
//  Medium.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "GenericManagedObject.h"

#define MEDIUM_ENTITY_NAME			@"Medium"

#define MEDIUM_KEY_URL				@"mediumUrl"
#define MEDIUM_KEY_MIMETYPE			@"mimeType"
#define MEDIUM_KEY_COMMENT			@"comment"

#define MEDIUM_REL_FISH				@"organism"


@class Organism;

@interface Medium : GenericManagedObject

@property (nonatomic, retain) NSString * mediumUrl;
@property (nonatomic, retain) NSString * mimeType;
@property (nonatomic, retain) NSString * comment;

@property (nonatomic, retain) Organism *organism;

@end
