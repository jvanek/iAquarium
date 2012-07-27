//
//  SearchBarTableViewController.h
//  AquaBase
//
//  Created by Vanek Josef on 26/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#define SEGUE_PUSH_DETAIL_ID		@"goToDetailID"
#define FISH_CELL_ID				@"FishCellID"


@interface SearchBarTableViewController : UIViewController<NSFetchedResultsControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
	BOOL isSearching;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPredicate *searchPredicate;
@property (strong, nonatomic) NSArray *searchResults;

- (IBAction)toggleSearchBar:(UIBarButtonItem *)sender;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)updateSearchResults:(NSString *)searchText;
- (NSString *)orgnanismConcreteEntityName;

@end
