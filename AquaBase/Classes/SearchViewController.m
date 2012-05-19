//
//  SearchViewControllerViewController.m
//  AquaBase
//
//  Created by Vaněk Josef on 10/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "SearchViewController.h"
#import "NetworkIndicatorController.h"
#import "DataController.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Fish.h"


@interface SearchViewController ()

@property (nonatomic, strong) NSMutableArray *searchCriteria;

- (SearchCriterium *)criteriumAtIndexPath:(NSIndexPath *)indexPath;
- (void)refreshDatabase:(UIBarButtonItem *)sender;

@end



@implementation SearchViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize tableView, searchCell;
@synthesize searchCriteria, searchButton;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithTitle:LOCALIZED_STRING(@"Refresh Database")
																style:UIBarButtonItemStyleBordered
															   target:self
															   action:@selector(refreshDatabase:)];
	self.navigationItem.rightBarButtonItem = refresh;

	self.searchCriteria = [NSMutableArray array];
	[self addCell:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (NSManagedObjectContext *)managedObjectContext {
	if (_managedObjectContext == nil) _managedObjectContext = APP_DELEGATE.managedObjectContext;
	return _managedObjectContext;
}

- (IBAction)goSearch:(UIButton *)sender {
//	NSArray *orderings = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:FISH_KEY_SCIENTIFIC_NAME ascending:YES]];
//	
//	// Fetch all fish using composed predicate from list
//	NSArray *results = [Fish fishUsingPredicate:nil andOrderings:orderings inContext:APP_DELEGATE.managedObjectContext];
	
	MasterViewController *next = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
	[self.navigationController pushViewController:next animated:YES];
}

- (IBAction)addCell:(UIButton *)sender {
	NSString *cellTitle = [NSString stringWithFormat:@"New condition %d", [self.searchCriteria count] + 1];
	if (sender != nil) {
		int index = sender.tag + 1;
		if (index >= 0 && index < [self.searchCriteria count])
			[self.searchCriteria insertObject:[SearchCriterium searchCriteriumWithTitle:cellTitle] atIndex:index];
		else [self.searchCriteria addObject:[SearchCriterium searchCriteriumWithTitle:cellTitle]];
	} else [self.searchCriteria addObject:[SearchCriterium searchCriteriumWithTitle:cellTitle]];
	[self.tableView reloadData];
}

- (IBAction)removeCell:(UIButton *)sender {
	int index = sender.tag;
	if (index >= 0 && index < [self.searchCriteria count]) {
		[self.searchCriteria removeObjectAtIndex:index];
		[self.tableView reloadData];
	}
}

- (void)predicateViewController:(PredicateViewController *)controller willCloseWithTitle:(NSString *)aTitle andPredicate:(NSComparisonPredicate *)aPredicate {
	
}

#pragma mark - TableView Methods

- (void)tableView:(UITableView *)aTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	SearchViewControllerCell *theCell = (SearchViewControllerCell *)cell;
	[theCell updateWithCriterium:[self.searchCriteria objectAtIndex:indexPath.row]];
	theCell.addCellButton.tag = indexPath.row;
	theCell.removeCellButton.tag = indexPath.row;
	if (indexPath.row == 0) theCell.removeCellButton.hidden = YES;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[aTableView deselectRowAtIndexPath:indexPath animated:NO];
	SearchCriterium *selectedCriterium = [self criteriumAtIndexPath:indexPath];
	PredicateViewController *next = [[PredicateViewController alloc] initWithNibName:@"PredicateViewController" bundle:nil];
	next.navigationItem.title = selectedCriterium.title;
	next.predicate = [selectedCriterium predicate];
	next.delegate = self;
	[self.navigationController pushViewController:next animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SearchViewControllerCell *cell = [aTableView dequeueReusableCellWithIdentifier:SearchViewControllerCellID];
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"SearchViewControllerCell" owner:self options:nil];
		cell = self.searchCell;
		self.searchCell = nil;
	}
	return cell;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	return [self.searchCriteria count];
}

- (BOOL)tableView:(UITableView *)aTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)tableView:(UITableView *)aTableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

#pragma mark - Private methods

- (SearchCriterium *)criteriumAtIndexPath:(NSIndexPath *)indexPath {
	return [self.searchCriteria objectAtIndex:indexPath.row];
}

- (void)refreshDatabase:(UIBarButtonItem *)sender {
	NSError *error = nil;
	NSURL *databaseUrl = [[NSBundle mainBundle] URLForResource:@"poissons-aquarium" withExtension:@"xml"];
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
//	APP_DELEGATE.networkIndicatorController.showsTitle = YES;
//	APP_DELEGATE.networkIndicatorController.showsSecondary = YES;
//	APP_DELEGATE.networkIndicatorController.showsProgress = YES;
//	[APP_DELEGATE.networkIndicatorController prepareWithMinValue:0.0 maxValue:0.0 forTitle:LOCALIZED_STRING(@"Refreshing...")];
//	[APP_DELEGATE performSelectorOnMainThread:@selector(showNetworkActivity) withObject:nil waitUntilDone:NO];
	
	BOOL result = [[DataController sharedInstance] updateDatabaseUsingURL:databaseUrl error:&error];
	if (!result) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCALIZED_STRING(@"Error")
														message:LOCALIZED_STRING(@"An error occured when updating the database. Please try again later.")
													   delegate:self
											  cancelButtonTitle:LOCALIZED_STRING(@"Ok")
											  otherButtonTitles:nil];
		[alert show];
	}
	
//	[APP_DELEGATE performSelectorOnMainThread:@selector(hideNetworkActivity) withObject:nil waitUntilDone:NO];
	self.navigationItem.rightBarButtonItem.enabled = YES;	
}

@end
