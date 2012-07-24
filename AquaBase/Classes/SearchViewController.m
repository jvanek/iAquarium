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
#import "SearchViewControllerCell.h"


@interface SearchViewController ()

@property (nonatomic, strong) NSMutableArray *searchCriteria;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) SearchViewControllerCell *selectedCell;

- (SearchCriterium *)criteriumAtIndexPath:(NSIndexPath *)indexPath;
- (void)refreshDatabase:(UIBarButtonItem *)sender;
- (void)showNetworkIndicator;

@end



@implementation SearchViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize tableView, selectedCell;
@synthesize searchCriteria, searchButton;
@synthesize selectedIndexPath;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
															   target:self
															   action:@selector(refreshDatabase:)];
	self.navigationItem.rightBarButtonItem = refresh;

	self.searchCriteria = [NSMutableArray array];
	[self addCell:nil];
	self.selectedIndexPath = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.selectedIndexPath = nil;
	self.selectedCell = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (NSManagedObjectContext *)managedObjectContext {
	if (_managedObjectContext == nil) _managedObjectContext = APP_DELEGATE.managedObjectContext;
	return _managedObjectContext;
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

- (void)predicateViewController:(PredicateViewController *)controller willCloseWithTitle:(NSString *)aTitle andPredicate:(NSPredicate *)aPredicate {
	SearchCriterium *criterium = [SearchCriterium searchCriteriumWithTitle:aTitle andPredicate:aPredicate];
	[self.searchCriteria replaceObjectAtIndex:self.selectedIndexPath.row withObject:criterium];
	[self.selectedCell updateWithCriterium:criterium];
	[self.tableView reloadData];
}

#pragma mark - UIStoryboard Delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];
	if ([SEGUE_PREDICATE_EDITOR_ID isEqualToString:segue.identifier]) {
		PredicateViewController *next = (PredicateViewController *)segue.destinationViewController;
		next.predicateTitle = self.selectedCell.criterium.title;
		next.predicate = self.selectedCell.criterium.predicate;
		next.delegate = self;
	} else if ([SEGUE_GO_SEARCH_ID isEqualToString:segue.identifier]) {
		MasterViewController *next = (MasterViewController *)segue.destinationViewController;
		next.searchPredicate = [self.searchCriteria count] > 1 ?
				[NSCompoundPredicate andPredicateWithSubpredicates:[self.searchCriteria valueForKey:@"predicate"]] :
				((SearchCriterium *)[self.searchCriteria lastObject]).predicate;
	}
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
	self.selectedCell = (SearchViewControllerCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	self.selectedIndexPath = indexPath;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SearchViewControllerCell *cell = [aTableView dequeueReusableCellWithIdentifier:SearchViewControllerCellID];
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

- (void)showNetworkIndicator {
	APP_DELEGATE.networkIndicatorController.showsTitle = YES;
	APP_DELEGATE.networkIndicatorController.showsSecondary = YES;
	APP_DELEGATE.networkIndicatorController.showsProgress = NO;
	[APP_DELEGATE.networkIndicatorController prepareWithMinValue:0.0 maxValue:0.0 forTitle:LOCALIZED_STRING(@"Refreshing...")];
	[APP_DELEGATE showNetworkActivity];
}

- (void)refreshDatabase:(UIBarButtonItem *)sender {
//	Poissons
//	NSURL *databaseUrl = [[NSBundle mainBundle] URLForResource:@"poissons-aquarium" withExtension:@"xml"];
	NSURL *remoteUrl = [NSURL URLWithString:@"http://www.aquabase.org/fish/dump.php3?format=xml"];
	
//	Plantes
//	NSURL *remoteUrl = [NSURL URLWithString:@"http://www.aquabase.org/plant/dump.php3?format=xml"];
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	[self performSelectorOnMainThread:@selector(showNetworkIndicator) withObject:nil waitUntilDone:NO];	
	
	[[DataController sharedInstance] updateDatabaseUsingURL:remoteUrl onCompletion:^(NSError *error) {
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
