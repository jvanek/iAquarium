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


static NSUInteger const kSizeOfFishBatch = 20;


@interface XmlParsingOperation() {
	int count, batchCount;
}

@property (nonatomic, strong) NSURL *remoteUrl;
@property (nonatomic, strong) NSMutableDictionary *currentItem;
@property (nonatomic, strong) NSMutableArray *currentParseBatch;

@end


@implementation XmlParsingOperation

@synthesize remoteUrl, currentItem, currentParseBatch;
@synthesize managedObjectContext, completionHandler;
@synthesize streamController, allowedElementNames;

- (id)initWithURL:(NSURL *)anUrl {
	if ((self = [super init]) != nil) {
		self.remoteUrl = anUrl;
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
	// managed object context ne doit pas etre cree dans init
	self.managedObjectContext = [[NSManagedObjectContext alloc] init];
	[self.managedObjectContext setUndoManager:nil];
	[self.managedObjectContext setPersistentStoreCoordinator:APP_DELEGATE.persistentStoreCoordinator];

	NSError *err = nil;
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
	return nil;
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
	batchCount++;
}

@end
