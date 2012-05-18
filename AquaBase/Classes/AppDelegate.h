//
//  AppDelegate.h
//  AquaBase
//
//  Created by Vaněk Josef on 10/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "SearchViewController.h"
#import "NetworkIndicatorController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) IBOutlet UINavigationController *mainViewController;
@property (strong, nonatomic) IBOutlet SearchViewController *searchViewController;
@property (nonatomic, strong) NetworkIndicatorController *networkIndicatorController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)showNetworkActivity;
- (void)hideNetworkActivity;

@end
