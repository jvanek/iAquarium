//
//  DetailViewController.m
//  AquaBase
//
//  Created by Vaněk Josef on 10/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "DetailViewController.h"
#import "DescriptionViewController.h"
#import "LifeValuesCell.h"
#import "LifeValues.h"
#import "CommonName.h"
#import "Fish.h"


@interface DetailViewController ()

@end



@implementation DetailViewController

@synthesize fishTableView, sections;
@synthesize detailItem;

#pragma mark - Managing the detail item

- (void)configureView {
    // Update the user interface for the detail item.
	self.sections = [NSMutableArray array];
	if (self.detailItem) {
		self.navigationItem.title = self.detailItem.scientificName;
		if (self.detailItem.commonNames != nil && [self.detailItem.commonNames count] > 0) [self.sections addObject:DETAIL_SECTION_COMMON_NAMES];
		if ([self.detailItem hasBiotopInformation]) [self.sections addObject:DETAIL_SECTION_BIOTOP];
		if ([self.detailItem hasDescriptions]) [self.sections addObject:DETAIL_SECTION_DESCRIPTIONS];
		if ([self.detailItem hasFactsInformation]) [self.sections addObject:DETAIL_SECTION_SIMPLE_VALUES];
	} else self.navigationItem.title = LOCALIZED_STRING(@"Detail");
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self configureView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];
	if ([SHOW_DESCRIPTION_SEGUE_ID isEqualToString:segue.identifier]) {
		NSIndexPath *indexPath = [self.fishTableView indexPathForSelectedRow];
		NSString *sectionTitle = [self.sections objectAtIndex:indexPath.section];
		DescriptionViewController *next = (DescriptionViewController *)segue.destinationViewController;
		if ([DETAIL_SECTION_FAMILY isEqualToString:sectionTitle]) {
			[next setupWithTitle:((Fish *)self.detailItem).family andContent:@"Family description goes here"];
		} else if ([DETAIL_SECTION_DESCRIPTIONS isEqualToString:sectionTitle]) {
			NSString *textKey = [[self.detailItem descriptionsKeys] objectAtIndex:indexPath.row];
			NSString *text = [[self.detailItem descriptionsValues] objectForKey:textKey];
			[next setupWithTitle:textKey andContent:text];
		}
	}
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.sections count];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self.sections objectAtIndex:section];
}

// Customize the appearance of table view cells.
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44.0;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	NSString *sectionTitle = [self.sections objectAtIndex:indexPath.section];
	if ([DETAIL_SECTION_COMMON_NAMES isEqualToString:sectionTitle]) {
		NSArray *descriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:COMMON_NAME_KEY_LABEL ascending:YES]];
		NSArray *sortedNames = [[self.detailItem.commonNames allObjects] sortedArrayUsingDescriptors:descriptors];
		cell.textLabel.text = [[sortedNames objectAtIndex:indexPath.row] label];
	} else if ([DETAIL_SECTION_FAMILY isEqualToString:sectionTitle]) {
		cell.textLabel.text = ((Fish *)self.detailItem).family;
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
