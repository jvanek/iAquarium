//
//  MasterViewController.h
//  AquaBase
//
//  Created by Vaněk Josef on 10/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#define SEGUE_PUSH_DETAIL_ID		@"goToDetailID"
#define FISH_CELL_ID				@"FishCellID"


@interface MasterViewController : UIViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
