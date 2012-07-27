//
//  PreferencesViewController.m
//  AquaBase
//
//  Created by Josef Vanek on 27/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "PreferencesViewController.h"
#import "DataController.h"


@interface PreferencesViewController ()

- (void)showNetworkIndicator;

@end



@implementation PreferencesViewController

- (void)showNetworkIndicator {
	APP_DELEGATE.networkIndicatorController.showsTitle = YES;
	APP_DELEGATE.networkIndicatorController.showsSecondary = YES;
	APP_DELEGATE.networkIndicatorController.showsProgress = NO;
	[APP_DELEGATE.networkIndicatorController prepareWithMinValue:0.0 maxValue:0.0 forTitle:LOCALIZED_STRING(@"Refreshing...")];
	[APP_DELEGATE showNetworkActivity];
}

- (IBAction)refreshFishDatabase:(UIButton *)sender {
	//	Poissons
	//	NSURL *databaseUrl = [[NSBundle mainBundle] URLForResource:@"poissons-aquarium" withExtension:@"xml"];
	NSURL *remoteUrl = [NSURL URLWithString:@"http://www.aquabase.org/fish/dump.php3?format=xml"];
	
	//	Plantes
	//	NSURL *remoteUrl = [NSURL URLWithString:@"http://www.aquabase.org/plant/dump.php3?format=xml"];
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	[self performSelectorOnMainThread:@selector(showNetworkIndicator) withObject:nil waitUntilDone:NO];
	
	[[DataController sharedInstance] updateDatabaseUsingURL:remoteUrl withXmlOperationType:XmlOperationFish onCompletion:^(NSError *error) {
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

- (IBAction)refreshPlantsDatabase:(UIButton *)sender {
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
