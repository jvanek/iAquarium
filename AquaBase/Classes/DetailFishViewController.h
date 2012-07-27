//
//  DetailFishViewController.h
//  AquaBase
//
//  Created by Josef Vanek on 27/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "DetailViewController.h"
#import "Fish.h"


#define DETAIL_CELL_ID					@"DetailCellID"
#define FACTS_DETAIL_CELL_ID			@"FactsDetailCellID"
#define DETAIL_NONSELECTABLE_CELL_ID	@"DetailNonSelectableCellID"

#define DETAIL_SECTION_COMMON_NAMES		LOCALIZED_STRING(@"Common names")
#define DETAIL_SECTION_FAMILY			LOCALIZED_STRING(@"Family")
#define DETAIL_SECTION_BIOTOP			LOCALIZED_STRING(@"Biotop")
#define DETAIL_SECTION_SIMPLE_VALUES	LOCALIZED_STRING(@"Facts")
#define DETAIL_SECTION_DESCRIPTIONS		LOCALIZED_STRING(@"Descriptions")



@interface DetailFishViewController : DetailViewController

@property (strong, nonatomic) Fish *detailItem;

@end
