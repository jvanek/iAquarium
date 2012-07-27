//
//  PlantParsingOperation.m
//  AquaBase
//
//  Created by Vanek Josef on 24/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "PlantParsingOperation.h"
#import "StreamKeys.h"
#import "Plant.h"


@implementation PlantParsingOperation

- (id)initWithURL:(NSURL *)anUrl {
	if ((self = [super initWithURL:anUrl]) != nil) {
		self.allowedElementNames = [NSArray arrayWithObjects:STREAM_KEY_PLANTE, STREAM_KEY_NOM_SCIENT, STREAM_KEY_NOM_COMMUN,
									STREAM_KEY_TEMPERATURE, STREAM_KEY_TEMP_MIN, STREAM_KEY_TEMP_MAX,
									STREAM_KEY_ACIDITE, STREAM_KEY_PHMIN, STREAM_KEY_PHMAX,
									STREAM_KEY_DURETE, STREAM_KEY_GHMIN, STREAM_KEY_GHMAX,
									STREAM_KEY_TAILLE_MIN, STREAM_KEY_TAILLE_MAX, STREAM_KEY_ORIGINE,
									STREAM_KEY_REPRODUCTION, STREAM_KEY_SUBSTRAT, STREAM_KEY_ECLAIRAGE,
									STREAM_KEY_EMPLACEMENT, STREAM_KEY_CROISSANCE, nil];
	}
	return self;
}

- (NSString *)xmlReaderItemElementName {
	return STREAM_KEY_PLANTE;
}

- (NSString *)parsedObjectEntityName {
	return PLANT_ENTITY_NAME;
}

@end
