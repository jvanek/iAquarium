//
//  DataController.m
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "DataController.h"
#import "XmlParsingOperation.h"


// Les mappings par plistes ne sont plus utilises
static NSMutableDictionary *objectMappings;
static NSMutableArray *mappingsNotFound;



@interface DataController()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) XmlParsingOperation *parsingOperation;

- (void)setup;

@end


@implementation DataController

@synthesize queue, parsingOperation;
@synthesize dateFormatter = _dateFormatter;


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
	[self.queue setMaxConcurrentOperationCount:1];
}

- (void)dealloc {
	self.queue = nil;
	self.parsingOperation = nil;
	self.dateFormatter = nil;
}

- (void)updateDatabaseUsingURL:(NSURL *)remoteUrl onCompletion:(void (^)(NSError *error))completionHandler {
	self.parsingOperation = [[XmlParsingOperation alloc] initWithURL:remoteUrl];
	if (completionHandler != nil) self.parsingOperation.completionHandler = completionHandler;
	else {
		self.parsingOperation.completionHandler = ^(NSError *error) {
			if (error != nil) NSLog(@"%s : Error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
			else NSLog(@"%s : Done.", __PRETTY_FUNCTION__);
		};
	}
	if (self.parsingOperation) [self.queue addOperation:self.parsingOperation];
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

@end
