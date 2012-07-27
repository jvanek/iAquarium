//
//  PlantsViewController.m
//  AquaBase
//
//  Created by Vanek Josef on 26/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "PlantsViewController.h"
#import "Plant.h"
#import "DetailPlantViewController.h"


@interface PlantsViewController ()

@end


@implementation PlantsViewController

- (NSString *)orgnanismConcreteEntityName {
	return PLANT_ENTITY_NAME;
}

#pragma mark - UIStoryboard Delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Plant *object = nil;
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	if (isSearching) object = [self.searchResults objectAtIndex:indexPath.row];
    else object = (Plant *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
	[(DetailPlantViewController *)segue.destinationViewController setDetailItem:object];
}

@end
