//
//  DetailFishViewController.m
//  AquaBase
//
//  Created by Josef Vanek on 27/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "DetailFishViewController.h"
#import "Fish.h"


@interface DetailFishViewController ()

@end



@implementation DetailFishViewController

@synthesize detailItem = _detailItem;

- (void)configureView {
    // Update the user interface for the detail item.
	[super configureView];
	Fish *ryba = (Fish *)self.detailItem;
	if (self.detailItem) {
		if (!IS_EMPTY_STRING(ryba.family)) [self.sections addObject:DETAIL_SECTION_FAMILY];
	} else self.navigationItem.title = LOCALIZED_STRING(@"Detail Fish");
}

@end
