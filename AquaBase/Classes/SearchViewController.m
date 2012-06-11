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
@property (nonatomic, strong) ComboboxController *combobox;
@property (nonatomic, strong) SearchCriterium *selectedCriterium;

- (SearchCriterium *)criteriumAtIndexPath:(NSIndexPath *)indexPath;
- (void)refreshDatabase:(UIBarButtonItem *)sender;
- (void)showNetworkIndicator;

@end



@implementation SearchViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize tableView;
@synthesize searchCriteria, searchButton;
@synthesize combobox, selectedCriterium;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
															   target:self
															   action:@selector(refreshDatabase:)];
	self.navigationItem.rightBarButtonItem = refresh;

	self.searchCriteria = [NSMutableArray array];
	[self addCell:nil];
	
	self.combobox = [[ComboboxController alloc] initWithDataSource:[NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", nil] displayStringKeypath:nil];
	self.combobox.delegate = self;
	self.combobox.view.frame = CGRectMake(20.0, 42.0, self.view.frame.size.width - 40.0, 40.0);
	[self.view addSubview:self.combobox.view];
	
	self.selectedCriterium = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.combobox = nil;
	self.selectedCriterium = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (self.combobox != nil) [self.combobox viewWillAppear:animated];
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

- (void)predicateViewController:(PredicateViewController *)controller willCloseWithTitle:(NSString *)aTitle andPredicate:(NSComparisonPredicate *)aPredicate {
	
}

#pragma mark - UIStoryboard Delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];
	if ([SEGUE_PREDICATE_EDITOR_ID isEqualToString:segue.identifier]) {
		PredicateViewController *next = (PredicateViewController *)segue.destinationViewController;
		next.navigationItem.title = selectedCriterium.title;
		next.predicate = [selectedCriterium predicate];
		next.delegate = self;
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
	self.selectedCriterium = [self criteriumAtIndexPath:indexPath];
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

#pragma mark - Combobox delegate

- (void)comboboxController:(ComboboxController *)controller didSelectObject:(id)selectedObject {
	NSLog(@"%s : %@", __PRETTY_FUNCTION__, selectedObject);
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
//	NSURL *databaseUrl = [[NSBundle mainBundle] URLForResource:@"poissons-aquarium" withExtension:@"xml"];
	NSURL *remoteUrl = [NSURL URLWithString:@"http://www.aquabase.org/fish/dump.php3?format=xml"];
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	[self performSelectorOnMainThread:@selector(showNetworkIndicator) withObject:nil waitUntilDone:NO];	
	
	[[DataController sharedInstance] updateDatabaseUsingURL:remoteUrl onCompletion:^(NSError *error) {
		[APP_DELEGATE performSelectorOnMainThread:@selector(hideNetworkActivity) withObject:nil waitUntilDone:NO];
		self.navigationItem.rightBarButtonItem.enabled = YES;		
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
