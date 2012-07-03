//
//  DescriptionViewController.m
//  AquaBase
//
//  Created by Vanek Josef on 03/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()

@end



@implementation DescriptionViewController

@synthesize contentView;


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.contentView.delegate = nil;
    self.contentView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
