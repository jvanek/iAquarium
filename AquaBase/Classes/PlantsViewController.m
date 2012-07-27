//
//  PlantsViewController.m
//  AquaBase
//
//  Created by Vanek Josef on 26/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "PlantsViewController.h"
#import "Plant.h"
#import "DataController.h"


@interface PlantsViewController ()

- (void)refreshDatabase:(UIBarButtonItem *)sender;
- (void)showNetworkIndicator;

@end


@implementation PlantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																			 target:self
																			 action:@selector(refreshDatabase:)];
	self.navigationItem.rightBarButtonItem = refresh;	
}

- (NSString *)orgnanismConcreteEntityName {
	return PLANT_ENTITY_NAME;
}

- (void)showNetworkIndicator {
	APP_DELEGATE.networkIndicatorController.showsTitle = YES;
	APP_DELEGATE.networkIndicatorController.showsSecondary = YES;
	APP_DELEGATE.networkIndicatorController.showsProgress = NO;
	[APP_DELEGATE.networkIndicatorController prepareWithMinValue:0.0 maxValue:0.0 forTitle:LOCALIZED_STRING(@"Refreshing...")];
	[APP_DELEGATE showNetworkActivity];
}

- (void)refreshDatabase:(UIBarButtonItem *)sender {
	//	Plantes
	NSURL *remoteUrl = [NSURL URLWithString:@"http://www.aquabase.org/plant/dump.php3?format=xml"];
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	[self performSelectorOnMainThread:@selector(showNetworkIndicator) withObject:nil waitUntilDone:NO];	
	
	[[DataController sharedInstance] updateDatabaseUsingURL:remoteUrl withXmlOperationType:XmlOperationPlants onCompletion:^(NSError *error) {
		[APP_DELEGATE performSelectorOnMainThread:@selector(hideNetworkActivity) withObject:nil waitUntilDone:NO];
		self.navigationItem.rightBarButtonItem.enabled = YES;
		//		[[DataController sharedInstance] updateIndexes];
		if (error != nil) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCALIZED_STRING(@"Error")
															message:LOCALIZED_STRING(@"An error occured when updating the database. Please try again later.")
														   delegate:self
												  cancelButtonTitle:LOCALIZED_STRING(@"Ok")
												  otherButtonTitles:nil];
			[alert show];
		}		
	}];
}

@end
