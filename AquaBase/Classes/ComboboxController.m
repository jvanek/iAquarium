//
//  ComboboxController.m
//  AquaBase
//
//  Created by Vaněk Josef on 04/06/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "ComboboxController.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface ComboboxController ()

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSString *displayKeyPath;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)updateSelectionLabel;

@end



@implementation ComboboxController

@synthesize tableView;
@synthesize selectionLabel;
@synthesize dataSource, displayKeyPath;
@synthesize delegate, selectedObject;


- (id)initWithDataSource:(NSArray *)aDataSource displayStringKeypath:(NSString *)keypath {
    if ((self = [super initWithNibName:@"ComboboxController" bundle:nil]) != nil) {
		self.dataSource = aDataSource;
		self.displayKeyPath = keypath;
    }
    return self;
}

- (void)dealloc {
	self.tableView.delegate = nil;
	self.tableView.dataSource = nil;
	self.tableView = nil;
	self.selectionLabel = nil;
	self.dataSource = nil;
	self.displayKeyPath = nil;
	self.delegate = nil;
	self.selectedObject = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	self.view.layer.cornerRadius = 5.0;
//	self.view.layer.masksToBounds = YES;
	self.selectedObject = [self.dataSource objectAtIndex:0];
	[self updateSelectionLabel];
}

- (IBAction)toggleSelectionList:(UIButton *)sender {
	CGRect container = self.view.frame;
	CGPoint origin = self.view.frame.origin;
	if ([self.tableView superview] != nil) {
		if (sender != nil) sender.enabled = NO;
		[UIView animateWithDuration:0.2
						 animations:^{
							 self.tableView.frame = CGRectMake(origin.x + 1.0, origin.y + container.size.height + 1.0, container.size.width - BUTTON_WIDTH - 1.0, 1.0);
						 }
						 completion:^(BOOL finished) {
							 [self.tableView removeFromSuperview];
							 if (sender != nil) sender.enabled = YES;
							 [self updateSelectionLabel];
						 }
		 ];
	}
	else {
		int maxVisibleLines = MIN(5, [self.dataSource count]);
		self.tableView.frame = CGRectMake(origin.x + 1.0, origin.y + container.size.height + 1.0, container.size.width - BUTTON_WIDTH, 1.0);
		[self.view.superview addSubview:self.tableView];
		if (sender != nil) sender.enabled = NO;
		[UIView animateWithDuration:0.2
						 animations:^{
							 self.tableView.frame = CGRectMake(origin.x + 1.0, origin.y + container.size.height + 1.0, container.size.width - BUTTON_WIDTH - 1.0, maxVisibleLines * DEFAULT_ROW_HEIGHT);
						 }
						 completion:^(BOOL finished) {
							 if (sender != nil) sender.enabled = YES;
						 }
		 ];
	}
}

- (void)updateSelectionLabel {
	self.selectionLabel.text = IS_EMPTY_STRING(self.displayKeyPath) ? self.selectedObject : [self.selectedObject valueForKeyPath:self.displayKeyPath];
}

#pragma mark - Table View

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	id anObject = [self.dataSource objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
	cell.textLabel.text = IS_EMPTY_STRING(self.displayKeyPath) ? anObject : [anObject valueForKeyPath:self.displayKeyPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return DEFAULT_ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ComboCellIdentifier = @"ComboBoxCell";    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:ComboCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ComboCellIdentifier];
    }	
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)aTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)aTableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedObject = [self.dataSource objectAtIndex:indexPath.row];
	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
	[self toggleSelectionList:nil];
	if (self.delegate != nil) [self.delegate comboboxController:self didSelectObject:self.selectedObject];
}

@end
