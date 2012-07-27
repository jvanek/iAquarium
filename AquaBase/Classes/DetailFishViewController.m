//
//  DetailFishViewController.m
//  AquaBase
//
//  Created by Josef Vanek on 27/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "DetailFishViewController.h"
#import "DescriptionViewController.h"
#import "CommonName.h"
#import "LifeValues.h"
#import "LifeValuesCell.h"

@interface DetailFishViewController ()

@end



@implementation DetailFishViewController

@synthesize detailItem = _detailItem;

- (void)configureView {
    // Update the user interface for the detail item.
	[super configureView];
	if (self.detailItem) {
		self.navigationItem.title = self.detailItem.scientificName;
		if (self.detailItem.commonNames != nil && [self.detailItem.commonNames count] > 0) [self.sections addObject:DETAIL_SECTION_COMMON_NAMES];
		if (!IS_EMPTY_STRING(self.detailItem.family)) [self.sections addObject:DETAIL_SECTION_FAMILY];
		if ([self.detailItem hasBiotopInformation]) [self.sections addObject:DETAIL_SECTION_BIOTOP];
		if ([self.detailItem hasFactsInformation]) [self.sections addObject:DETAIL_SECTION_SIMPLE_VALUES];
		if ([self.detailItem hasDescriptions]) [self.sections addObject:DETAIL_SECTION_DESCRIPTIONS];
	} else self.navigationItem.title = @"";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];
	if ([SHOW_DESCRIPTION_SEGUE_ID isEqualToString:segue.identifier]) {
		NSIndexPath *indexPath = [self.fishTableView indexPathForSelectedRow];
		NSString *sectionTitle = [self.sections objectAtIndex:indexPath.section];
		DescriptionViewController *next = (DescriptionViewController *)segue.destinationViewController;
		if ([DETAIL_SECTION_FAMILY isEqualToString:sectionTitle]) {
			[next setupWithTitle:self.detailItem.family andContent:@"Family description goes here"];
		} else if ([DETAIL_SECTION_DESCRIPTIONS isEqualToString:sectionTitle]) {
			NSString *textKey = [[self.detailItem descriptionsKeys] objectAtIndex:indexPath.row];
			NSString *text = [[self.detailItem descriptionsValues] objectForKey:textKey];
			[next setupWithTitle:textKey andContent:text];
		}
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *sectionTitle = [self.sections objectAtIndex:section];
	if ([DETAIL_SECTION_COMMON_NAMES isEqualToString:sectionTitle]) {
		return [self.detailItem.commonNames count];
	}
	else if ([DETAIL_SECTION_FAMILY isEqualToString:sectionTitle]) {
		return 1;
	}
	else if ([DETAIL_SECTION_BIOTOP isEqualToString:sectionTitle]) {
		return [self.detailItem biotopRowCount];
	}
	else if ([DETAIL_SECTION_SIMPLE_VALUES isEqualToString:sectionTitle]) {
		return [self.detailItem factsRowCount];
	}
	else if ([DETAIL_SECTION_DESCRIPTIONS isEqualToString:sectionTitle]) {
		return [self.detailItem descriptionsRowCount];
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
	NSString *sectionTitle = [self.sections objectAtIndex:indexPath.section];
	if ([DETAIL_SECTION_COMMON_NAMES isEqualToString:sectionTitle]) {
		cell = [tableView dequeueReusableCellWithIdentifier:DETAIL_NONSELECTABLE_CELL_ID];
	} else if ([DETAIL_SECTION_BIOTOP isEqualToString:sectionTitle]) {
		cell = [tableView dequeueReusableCellWithIdentifier:LIFE_VALUES_CELL_ID];
	} else if ([DETAIL_SECTION_SIMPLE_VALUES isEqualToString:sectionTitle]) {
		cell = [tableView dequeueReusableCellWithIdentifier:FACTS_DETAIL_CELL_ID];
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:DETAIL_CELL_ID];
	}
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	NSString *sectionTitle = [self.sections objectAtIndex:indexPath.section];
	if ([DETAIL_SECTION_COMMON_NAMES isEqualToString:sectionTitle]) {
		NSArray *descriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:COMMON_NAME_KEY_LABEL ascending:YES]];
		NSArray *sortedNames = [[self.detailItem.commonNames allObjects] sortedArrayUsingDescriptors:descriptors];
		cell.textLabel.text = [[sortedNames objectAtIndex:indexPath.row] label];
	} else if ([DETAIL_SECTION_FAMILY isEqualToString:sectionTitle]) {
		cell.textLabel.text = self.detailItem.family;
	} else if ([DETAIL_SECTION_BIOTOP isEqualToString:sectionTitle]) {
		NSString *biotopKey = [[self.detailItem biotopKeys] objectAtIndex:indexPath.row];
		LifeValues *lv = [[self.detailItem biotopValues] objectForKey:biotopKey];
		[(LifeValuesCell *)cell configureWithLifeValues:lv forTitle:biotopKey];
	} else if ([DETAIL_SECTION_SIMPLE_VALUES isEqualToString:sectionTitle]) {
		NSString *factKey = [[self.detailItem factsKeys] objectAtIndex:indexPath.row];
		cell.textLabel.text = factKey;
		cell.detailTextLabel.text = [[self.detailItem factsValues] objectForKey:factKey];
	} else if ([DETAIL_SECTION_DESCRIPTIONS isEqualToString:sectionTitle]) {
		NSString *textKey = [[self.detailItem descriptionsKeys] objectAtIndex:indexPath.row];
		cell.textLabel.text = textKey;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else cell.textLabel.text = @"";
}

@end
