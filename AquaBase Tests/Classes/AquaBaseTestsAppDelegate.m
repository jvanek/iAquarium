//
//  GHUnitIPhoneAppDelegate+Additions.m
//  BusinessTalk
//
//  Created by Vanek Josef on 21/12/11.
//  Copyright (c) 2011 Pallas Free Foundation. All rights reserved.
//

#import "AquaBaseTestsAppDelegate.h"



@implementation AquaBaseTestsAppDelegate


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

 //Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext == nil) {
		NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
		if (coordinator != nil) {
			_managedObjectContext = [[NSManagedObjectContext alloc] init];
			[_managedObjectContext setPersistentStoreCoordinator:coordinator];
		}
	}
    return _managedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
 
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
		NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AquaBase" withExtension:@"momd"];
		_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	}
    return _managedObjectModel;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
 
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
		NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AquaBase-Tests.sqlite"];
		NSLog(@"%s : Using database at: %@", __PRETTY_FUNCTION__, [storeURL path]);
		NSError *error = nil;
		_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
														configuration:nil
																  URL:storeURL
															  options:nil
																error:&error]) {
			NSLog(@"%s : Unresolved error %@, %@", __PRETTY_FUNCTION__, error, [error userInfo]);
			abort();
		}
    }
    return _persistentStoreCoordinator;
}
 
/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
