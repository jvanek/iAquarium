//
//  SearchViewControllerViewController.h
//  AquaBase
//
//  Created by Vaněk Josef on 10/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "PredicateViewController.h"


#define SEGUE_PREDICATE_EDITOR_ID		@"goToPredicateID"

@interface SearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, PredicateViewControllerDelegate,
									UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIButton *searchButton;

- (IBAction)addCell:(UIButton *)sender;
- (IBAction)removeCell:(UIButton *)sender;

@end
