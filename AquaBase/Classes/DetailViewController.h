//
//  DetailViewController.h
//  AquaBase
//
//  Created by Vaněk Josef on 10/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "Fish.h"
#import "LifeValuesCell.h"


#define DETAIL_SECTION_COMMON_NAMES		LOCALIZED_STRING(@"Common names")
#define DETAIL_SECTION_FAMILY			LOCALIZED_STRING(@"Family")
#define DETAIL_SECTION_BIOTOP			LOCALIZED_STRING(@"Biotop")
#define DETAIL_SECTION_SIMPLE_VALUES	LOCALIZED_STRING(@"Facts")


@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Fish *detailItem;
@property (strong, nonatomic) IBOutlet UITableView *fishTableView;
@property (strong, nonatomic) IBOutlet LifeValuesCell *lifeValuesCell;
@property (strong, nonatomic) NSMutableArray *sections;

- (id)initWithFish:(Fish *)aFish;

@end
