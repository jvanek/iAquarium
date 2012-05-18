//
//  PredicateViewController.m
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Intellicore. All rights reserved.
//

#import "PredicateViewController.h"

@interface PredicateViewController ()

@property (nonatomic, strong) IBOutlet UITextField *titleField;

@end



@implementation PredicateViewController

@synthesize predicate, delegate;
@synthesize titleField;


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if (self.delegate != nil) [self.delegate predicateViewController:self willCloseWithTitle:self.titleField.text andPredicate:self.predicate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	self.delegate = nil;
	self.predicate = nil;
	self.titleField = nil;
}

@end
