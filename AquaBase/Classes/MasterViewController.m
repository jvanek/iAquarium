//
//  MasterViewController.m
//  AquaBase
//
//  Created by Vaněk Josef on 10/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "MasterViewController.h"
#import "Fish.h"
#import "DetailFishViewController.h"


@interface MasterViewController ()

@end



@implementation MasterViewController

- (NSString *)orgnanismConcreteEntityName {
	return FISH_ENTITY_NAME;
}

#pragma mark - UIStoryboard Delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Fish *object = nil;
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	if (isSearching) object = [self.searchResults objectAtIndex:indexPath.row];
    else object = (Fish *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
	[(DetailFishViewController *)segue.destinationViewController setDetailItem:object];
}

@end
