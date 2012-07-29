//
//  DetailPlantViewController.m
//  AquaBase
//
//  Created by Josef Vanek on 27/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "DetailPlantViewController.h"

@interface DetailPlantViewController ()

@end

@implementation DetailPlantViewController

@synthesize detailItem = _detailItem;

- (void)configureView {
    // Update the user interface for the detail item.
	[super configureView];
	if (self.detailItem == nil) self.navigationItem.title = LOCALIZED_STRING(@"Detail Plant");
}

@end
