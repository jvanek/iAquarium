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


@interface XmlParsingOperation() {
	int count;
}

@property (nonatomic, strong) NSURL *remoteUrl;
@property (nonatomic, strong) NSMutableDictionary *currentItem;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@implementation XmlParsingOperation

@synthesize remoteUrl, currentItem;
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
	self.streamController = [[StreamController alloc] init];
	self.streamController.delegate = self;
	[self.streamController parseXmlFromUrl:remoteUrl error:&err];
	[self.managedObjectContext save:&err];
	if (self.completionHandler) self.completionHandler();
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

- (void)xmlReaderAddToList:(id)currentItem {
#ifdef DEBUG_XML
	NSLog(@"%s : Adding to database %@", __PRETTY_FUNCTION__, [self.currentItem description]);
#endif
	[GenericManagedObject updateObjectForKey:FISH_KEY_SCIENTIFIC_NAME
									   value:[self.currentItem objectForKey:STREAM_KEY_NOM_SCIENT]
								  entityName:FISH_ENTITY_NAME
							  fromDictionary:self.currentItem
						   orCreateInContext:self.managedObjectContext];
}

@end
