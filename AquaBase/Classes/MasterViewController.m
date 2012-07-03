//
//  MasterViewController.m
//  AquaBase
//
//  Created by Vaněk Josef on 10/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Fish.h"
#import "CommonName.h"


@interface MasterViewController () {
	BOOL isSearching;
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSArray *searchResults;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)updateSearchResults:(NSString *)searchText;

@end



@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize tableView, searchResults;
@synthesize searchPredicate = _searchPredicate;


							
- (void)viewDidLoad {
    [super viewDidLoad];
//	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.title = LOCALIZED_STRING(@"Search Results");
//		self.clearsSelectionOnViewWillAppear = NO;
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	isSearching = NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.detailViewController = nil;
	self.fetchedResultsController.delegate = nil;
	self.fetchedResultsController = nil;
	self.managedObjectContext = nil;
	self.tableView = nil;
	self.searchResults = nil;
	self.searchPredicate = nil;
}

- (void)dealloc {
	self.detailViewController = nil;
	self.fetchedResultsController.delegate = nil;
	self.fetchedResultsController = nil;
	self.managedObjectContext = nil;
	self.tableView = nil;
	self.searchResults = nil;
	self.searchPredicate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - UIStoryboard Delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Fish *object = nil;
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	if (isSearching) object = [self.searchResults objectAtIndex:indexPath.row];
    else object = (Fish *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
	((DetailViewController *)segue.destinationViewController).detailItem = object;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	return isSearching ? 1 : [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	if (isSearching) return [self.searchResults count];
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
	return isSearching ? [NSString stringWithFormat:LOCALIZED_STRING(@"Search results %d"), [self.searchResults count]] :
						[[self.fetchedResultsController sectionIndexTitles] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView {
	return isSearching ? nil : [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)aTableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	return isSearching ? 0 : [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:FISH_CELL_ID];
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)aTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)aTableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[aTableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Fetched results controller

- (NSManagedObjectContext *)managedObjectContext {
	if (__managedObjectContext == nil) __managedObjectContext = APP_DELEGATE.managedObjectContext;
	return __managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:FISH_ENTITY_NAME];
    if (self.searchPredicate != nil) [fetchRequest setPredicate:self.searchPredicate];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:FISH_KEY_SCIENTIFIC_NAME ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																								managedObjectContext:self.managedObjectContext
																								  sectionNameKeyPath:FISH_KEY_SECTION
																										   cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *aTableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [aTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[aTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [aTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Fish *object = nil;
	if (isSearching) object = [self.searchResults objectAtIndex:indexPath.row];
    else object = (Fish *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    cell.textLabel.text = object.scientificName;
	cell.detailTextLabel.text = [[[object.commonNames valueForKey:COMMON_NAME_KEY_LABEL] allObjects] componentsJoinedByString:@", "];
}

#pragma mark - UISearchBarDelegate

- (void)updateSearchResults:(NSString *)searchText {
	if (IS_EMPTY_STRING(searchText)) {
		self.searchResults = [NSArray array];
		isSearching = NO;
	} else {
		NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@ or %K.%K contains[cd] %@", 
										FISH_KEY_SCIENTIFIC_NAME, searchText, FISH_REL_COMMON_NAMES, COMMON_NAME_KEY_LABEL, searchText];
		self.searchResults = [self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:filterPredicate];
		isSearching = YES;
	}
	[self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	[self updateSearchResults:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self updateSearchResults:nil];
	if (APP_DELEGATE.isIphone) [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self updateSearchResults:searchBar.text];
	if (APP_DELEGATE.isIphone) [searchBar resignFirstResponder];
}

@end
