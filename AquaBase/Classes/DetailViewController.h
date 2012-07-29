//
//  DetailViewController.h
//  AquaBase
//
//  Created by Vaněk Josef on 10/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "Organism.h"

#define SHOW_DESCRIPTION_SEGUE_ID		@"showDescriptionSegueID"

#define DETAIL_CELL_ID					@"DetailCellID"
#define FACTS_DETAIL_CELL_ID			@"FactsDetailCellID"
#define DETAIL_NONSELECTABLE_CELL_ID	@"DetailNonSelectableCellID"

#define DETAIL_SECTION_COMMON_NAMES		LOCALIZED_STRING(@"Common names")
#define DETAIL_SECTION_BIOTOP			LOCALIZED_STRING(@"Biotop")
#define DETAIL_SECTION_DESCRIPTIONS		LOCALIZED_STRING(@"Descriptions")

// Fish specific
#define DETAIL_SECTION_FAMILY			LOCALIZED_STRING(@"Family")
#define DETAIL_SECTION_SIMPLE_VALUES	LOCALIZED_STRING(@"Facts")
#define DETAIL_SECTION_GENDER_VALUES	LOCALIZED_STRING(@"Specific values")

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *fishTableView;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) Organism *detailItem;

- (void)configureView;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
