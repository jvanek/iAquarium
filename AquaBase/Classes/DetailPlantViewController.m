//
//  DetailPlantViewController.m
//  AquaBase
//
//  Created by Josef Vanek on 27/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "DetailPlantViewController.h"

@interface DetailPlantViewController ()

@end

@implementation DetailPlantViewController

@synthesize detailItem = _detailItem;

- (void)configureView {
    // Update the user interface for the detail item.
	[super configureView];
	if (self.detailItem) {
		self.navigationItem.title = self.detailItem.scientificName;
	} else self.navigationItem.title = @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *sectionTitle = [self.sections objectAtIndex:section];
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
	cell = [tableView dequeueReusableCellWithIdentifier:PlantDetailCellID];
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	NSString *sectionTitle = [self.sections objectAtIndex:indexPath.section];
	cell.textLabel.text = @"";
}

@end
