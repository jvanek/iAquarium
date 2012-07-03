//
//  UpdateSectionsOperation.m
//  AquaBase
//
//  Created by Vanek Josef on 03/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "UpdateSectionsOperation.h"
#import "Fish.h"


@interface UpdateSectionsOperation()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
- (void)saveAll;
@end


@implementation UpdateSectionsOperation

@synthesize managedObjectContext;

- (id)init {
	if ((self = [super init]) != nil) {
		self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setUndoManager:nil];
        [self.managedObjectContext setPersistentStoreCoordinator:APP_DELEGATE.persistentStoreCoordinator];
		[self.managedObjectContext setMergePolicy:[[NSMergePolicy alloc] initWithMergeType:NSOverwriteMergePolicyType]];
	}
	return self;
}

- (void)dealloc {
	self.managedObjectContext = nil;
}

- (void)saveAll {
	NSError *err = nil;
	int toBeUpdated = [[self.managedObjectContext updatedObjects] count];
	if (![self.managedObjectContext save:&err]) LOG(@"Error when updating indexes: %@", [err localizedDescription]);
	else LOG(@"Updated %d records", toBeUpdated);	
}

- (void)main {
	NSArray *fish = [Fish fishUsingPredicate:nil andOrderings:nil inContext:self.managedObjectContext];
	for (Fish *aFish in fish) [aFish updateSectionIndex];
	[self performSelectorOnMainThread:@selector(saveAll) withObject:nil waitUntilDone:NO];
}

@end
