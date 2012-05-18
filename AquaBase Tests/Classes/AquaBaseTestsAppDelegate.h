//
//  GHUnitIPhoneAppDelegate+Additions.h
//  BusinessTalk
//
//  Created by Vanek Josef on 21/12/11.
//  Copyright (c) 2011 Pallas Free Foundation. All rights reserved.
//

#import <GHUnitIOS/GHUnitIPhoneAppDelegate.h>


@interface AquaBaseTestsAppDelegate : GHUnitIPhoneAppDelegate

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory;

@end
