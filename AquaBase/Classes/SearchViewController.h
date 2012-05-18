//
//  SearchViewControllerViewController.h
//  AquaBase
//
//  Created by Vaněk Josef on 10/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "SearchViewControllerCell.h"
#import "PredicateViewController.h"


@interface SearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, PredicateViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) IBOutlet SearchViewControllerCell *searchCell;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIButton *searchButton;

- (IBAction)goSearch:(UIButton *)sender;
- (IBAction)addCell:(UIButton *)sender;
- (IBAction)removeCell:(UIButton *)sender;

@end
