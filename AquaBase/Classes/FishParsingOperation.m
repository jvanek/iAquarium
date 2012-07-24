//
//  FishParsingOperation.m
//  AquaBase
//
//  Created by Vanek Josef on 24/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "FishParsingOperation.h"
#import "StreamKeys.h"
#import "Fish.h"


@implementation FishParsingOperation

- (id)initWithURL:(NSURL *)anUrl {
	if ((self = [super initWithURL:anUrl]) != nil) {
		self.allowedElementNames = [NSArray arrayWithObjects:STREAM_KEY_POISSON, STREAM_KEY_NOM_SCIENT,
									STREAM_KEY_NOM_COMMUN, STREAM_KEY_DESCRIPTEUR, STREAM_KEY_FAMILLE, STREAM_KEY_TEMPERATURE,
									STREAM_KEY_TEMP_MIN, STREAM_KEY_TEMP_MAX, STREAM_KEY_TEMP_REPRO, STREAM_KEY_ACIDITE,
									STREAM_KEY_PHMIN, STREAM_KEY_PHMAX, STREAM_KEY_PHREPRO, STREAM_KEY_DURETE,		
									STREAM_KEY_GHMIN, STREAM_KEY_GHMAX, STREAM_KEY_GHREPRO,
									STREAM_KEY_TAILLE_MALE, STREAM_KEY_TAILLE_FEMELLE, STREAM_KEY_ESPERANCE_VIE, STREAM_KEY_ZONE_VIE,		
									STREAM_KEY_ORIGINE, STREAM_KEY_DESCRIPTION, STREAM_KEY_DIMORPHISME, STREAM_KEY_COMPORTEMENT,	
									STREAM_KEY_REPRODUCTION, nil];
	}
	return self;
}

- (NSString *)xmlReaderItemElementName {
	return STREAM_KEY_POISSON;
}

#pragma mark - Batch methods

- (void)addBatchToDatabase:(NSArray *)batch {
	NSError *error = nil;
	for (NSDictionary *aDict in batch) {
#ifdef DEBUG_XML
		NSLog(@"%s : Adding to database %@", __PRETTY_FUNCTION__, [self.currentItem description]);
#endif
		[GenericManagedObject updateObjectForKey:ORGANISM_KEY_SCIENTIFIC_NAME
										   value:[aDict objectForKey:STREAM_KEY_NOM_SCIENT]
									  entityName:FISH_ENTITY_NAME
								  fromDictionary:aDict
							   orCreateInContext:self.managedObjectContext];
	}
	
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%s : Unresolved error %@, %@", __PRETTY_FUNCTION__, error, [error userInfo]);
        abort();
    }

	[super addBatchToDatabase:batch];
}

@end
