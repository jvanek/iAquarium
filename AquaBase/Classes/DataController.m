//
//  DataController.m
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "DataController.h"
#import "NSString+Additions.h"
#import "StreamKeys.h"
#import "Fish.h"


// Les mappings par plistes ne sont plus utilises
static NSMutableDictionary *objectMappings;
static NSMutableArray *mappingsNotFound;



@interface DataController()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableDictionary *currentItem;

- (void)setup;

@end


@implementation DataController

@synthesize queue, streamController, allowedElementNames;
@synthesize currentItem, dateFormatter = _dateFormatter;


+ (DataController *)sharedInstance {
    static dispatch_once_t pred = 0; 
    __strong static DataController *_sharedDataObject = nil;
    dispatch_once(&pred, ^{
		_sharedDataObject = [self new];
		[_sharedDataObject setup];
    });	
    return _sharedDataObject;
}

- (void)setup {
	self.queue = [[NSOperationQueue alloc] init];
	self.allowedElementNames = [NSArray arrayWithObjects:STREAM_KEY_POISSON, STREAM_KEY_NOM_SCIENT,
								STREAM_KEY_NOM_COMMUN, STREAM_KEY_DESCRIPTEUR, STREAM_KEY_FAMILLE, STREAM_KEY_TEMPERATURE,
								STREAM_KEY_TEMP_MIN, STREAM_KEY_TEMP_MAX, STREAM_KEY_TEMP_REPRO, STREAM_KEY_ACIDITE,
								STREAM_KEY_PHMIN, STREAM_KEY_PHMAX, STREAM_KEY_PHREPRO, STREAM_KEY_DURETE,		
								STREAM_KEY_GHMIN, STREAM_KEY_GHMAX, STREAM_KEY_GHREPRO,
								STREAM_KEY_TAILLE_MALE, STREAM_KEY_TAILLE_FEMELLE, STREAM_KEY_ESPERANCE_VIE, STREAM_KEY_ZONE_VIE,		
								STREAM_KEY_ORIGINE, STREAM_KEY_DESCRIPTION, STREAM_KEY_DIMORPHISME, STREAM_KEY_COMPORTEMENT,	
								STREAM_KEY_REPRODUCTION, nil];
	self.currentItem = nil;
}

- (void)dealloc {
	self.queue = nil;
	self.streamController = nil;
	self.allowedElementNames = nil;
	self.currentItem = nil;
}

- (BOOL)updateDatabaseUsingURL:(NSURL *)remoteUrl error:(NSError **)error {
	BOOL result = YES;
	self.streamController = [[StreamController alloc] init];
	self.streamController.delegate = self;
	result = [self.streamController parseXmlFromUrl:remoteUrl error:error];
	[APP_DELEGATE.managedObjectContext save:error];
	return result;
}

/*!
 * Les entity mappings ne sont plus chargees des plistes, mais stockees dans le modele comme le dictionnaire
 * userInfo
 */
+ (NSDictionary *)mappingForEntityName:(NSString *)entityName {
	if (objectMappings == nil) objectMappings = [NSMutableDictionary dictionary];
	if (mappingsNotFound == nil) mappingsNotFound = [NSMutableArray array];
	
	NSDictionary *mapping = [objectMappings objectForKey:entityName];
	if (mapping == nil && ![mappingsNotFound containsObject:entityName]) {
		NSString *mappingFileName = [NSString stringWithFormat:@"%@-mapping", entityName];
		NSString *mappingFilePath = [[NSBundle mainBundle] pathForResource:mappingFileName ofType:@"plist"];
		mapping = (mappingFilePath != nil) ? [NSDictionary dictionaryWithContentsOfFile:mappingFilePath] : nil;
		if (mapping != nil) {
			[objectMappings setObject:mapping forKey:entityName];
#ifdef DEBUG
			NSLog(@"%s : Mapping for %@ found", __PRETTY_FUNCTION__, entityName);
#endif
		} else {
			[mappingsNotFound addObject:entityName];
#ifdef DEBUG
			NSLog(@"%s : Mapping for %@ not found", __PRETTY_FUNCTION__, entityName);
#endif
		}
	}
	//	NSDictionary *mapping = nil;
	//	NSEntityDescription *entDesc = [[APP_DELEGATE.managedObjectModel entitiesByName] objectForKey:entityName];
	//	if (entDesc != nil) mapping = ([entDesc.userInfo count] > 0) ? entDesc.userInfo : nil;
	return mapping;
}

- (NSDateFormatter *)dateFormatter {
	if (_dateFormatter == nil) {
		_dateFormatter = [[NSDateFormatter alloc] init];
		[_dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[_dateFormatter setDateFormat:NETWORK_DATA_DATE_FORMAT];
	}
	return _dateFormatter;
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
						   orCreateInContext:APP_DELEGATE.managedObjectContext];
}

@end
