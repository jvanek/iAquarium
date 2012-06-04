//
//  XmlParsingOperation.m
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "XmlParsingOperation.h"
#import "NSString+Additions.h"
#import "StreamKeys.h"
#import "Fish.h"


static NSUInteger const kSizeOfFishBatch = 20;


@interface XmlParsingOperation() {
	int count, batchCount;
}

@property (nonatomic, strong) NSURL *remoteUrl;
@property (nonatomic, strong) NSMutableDictionary *currentItem;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *currentParseBatch;

- (void)addBatchToDatabase:(NSArray *)batch;

@end


@implementation XmlParsingOperation

@synthesize remoteUrl, currentItem, currentParseBatch;
@synthesize managedObjectContext, completionHandler;
@synthesize streamController, allowedElementNames;

- (id)initWithURL:(NSURL *)anUrl {
	if ((self = [super init]) != nil) {
		self.remoteUrl = anUrl;
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setUndoManager:nil];
        [self.managedObjectContext setPersistentStoreCoordinator:APP_DELEGATE.persistentStoreCoordinator];
	}
	return self;
}

- (void)dealloc {
	self.remoteUrl = nil;
	self.currentItem = nil;
	self.managedObjectContext = nil;
	self.streamController = nil;
	self.allowedElementNames = nil;
	self.currentParseBatch = nil;
}

- (void)main {
	NSError *err = nil;
	self.allowedElementNames = [NSArray arrayWithObjects:STREAM_KEY_POISSON, STREAM_KEY_NOM_SCIENT,
								STREAM_KEY_NOM_COMMUN, STREAM_KEY_DESCRIPTEUR, STREAM_KEY_FAMILLE, STREAM_KEY_TEMPERATURE,
								STREAM_KEY_TEMP_MIN, STREAM_KEY_TEMP_MAX, STREAM_KEY_TEMP_REPRO, STREAM_KEY_ACIDITE,
								STREAM_KEY_PHMIN, STREAM_KEY_PHMAX, STREAM_KEY_PHREPRO, STREAM_KEY_DURETE,		
								STREAM_KEY_GHMIN, STREAM_KEY_GHMAX, STREAM_KEY_GHREPRO,
								STREAM_KEY_TAILLE_MALE, STREAM_KEY_TAILLE_FEMELLE, STREAM_KEY_ESPERANCE_VIE, STREAM_KEY_ZONE_VIE,		
								STREAM_KEY_ORIGINE, STREAM_KEY_DESCRIPTION, STREAM_KEY_DIMORPHISME, STREAM_KEY_COMPORTEMENT,	
								STREAM_KEY_REPRODUCTION, nil];
	self.currentItem = nil;
	count = 0;
	batchCount = 0;
	self.currentParseBatch = [NSMutableArray array];

	self.streamController = [[StreamController alloc] init];
	self.streamController.delegate = self;
	[self.streamController parseXmlFromUrl:remoteUrl error:&err];

    if (![self isCancelled]) {
        if ([self.currentParseBatch count] > 0) {
			[self performSelectorOnMainThread:@selector(addBatchToDatabase:)
								   withObject:self.currentParseBatch
								waitUntilDone:NO];
        }
    }

	NSLog(@"%s : Added %d objects (%d batches)", __PRETTY_FUNCTION__, count, batchCount);

	if (self.completionHandler) self.completionHandler(err);	
}

#pragma mark - StreamControllerDelegate methods

- (id)xmlReaderItem {
	self.currentItem = [NSMutableDictionary dictionary];
	return self.currentItem;
}

- (NSString *)xmlReaderItemElementName {
	return STREAM_KEY_POISSON;
}

- (BOOL)xmlReaderIsValidParsingElementName:(NSString *)elementName {
	return [self.allowedElementNames containsObject:elementName];
}

- (void)xmlReaderParsedString:(NSString *)content forElementName:(NSString *)elementName {
	if ([STREAM_KEY_NOM_COMMUN isEqualToString:elementName]) {
		NSMutableArray *nomsCommuns = [self.currentItem objectForKey:STREAM_KEY_NOM_COMMUNS];
		if (nomsCommuns == nil) nomsCommuns = [NSMutableArray array];
		[nomsCommuns addObject:[content trim]];
		[self.currentItem setObject:nomsCommuns forKey:STREAM_KEY_NOM_COMMUNS];
	} else {
		[self.currentItem setObject:[content trim] forKey:elementName];
	}
}

- (void)xmlReaderAddToList:(id)anItem {
	count++;
	[self.currentParseBatch addObject:self.currentItem];
	if ([self.currentParseBatch count] >= kSizeOfFishBatch) {
		[self performSelectorOnMainThread:@selector(addBatchToDatabase:)
							   withObject:self.currentParseBatch
							waitUntilDone:NO];
		self.currentParseBatch = [NSMutableArray array];
	}
}

#pragma mark - Batch methods

- (void)addBatchToDatabase:(NSArray *)batch {
	NSError *error = nil;
	for (NSDictionary *aDict in batch) {
#ifdef DEBUG_XML
		NSLog(@"%s : Adding to database %@", __PRETTY_FUNCTION__, [self.currentItem description]);
#endif
		[GenericManagedObject updateObjectForKey:FISH_KEY_SCIENTIFIC_NAME
										   value:[aDict objectForKey:STREAM_KEY_NOM_SCIENT]
									  entityName:FISH_ENTITY_NAME
								  fromDictionary:aDict
							   orCreateInContext:self.managedObjectContext];
	}
	
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate.
        // You should not use this function in a shipping application, although it may be useful
        // during development. If it is not possible to recover from the error, display an alert
        // panel that instructs the user to quit the application by pressing the Home button.
        //
        NSLog(@"%s : Unresolved error %@, %@", __PRETTY_FUNCTION__, error, [error userInfo]);
        abort();
    }
	
	batchCount++;
}

@end
