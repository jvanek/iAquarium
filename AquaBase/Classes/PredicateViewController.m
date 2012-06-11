//
//  PredicateViewController.m
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "PredicateViewController.h"
#import "Fish.h"


@interface PredicateViewController ()

@property (nonatomic, strong) ComboboxController *attrCombobox, *operCombobox;

- (NSPredicateOperatorType)operatorTypeFromString:(NSString *)operator;

@end



@implementation PredicateViewController

@synthesize predicate, delegate;
@synthesize titleField, attrCombobox;
@synthesize attrComboContainer, operComboContainer;
@synthesize valueField, operCombobox;


- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = LOCALIZED_STRING(@"Edit Predicate");
	
	self.attrCombobox = [[ComboboxController alloc] initWithDataSource:[Fish attributesToQuery] displayStringKeypath:nil];
	self.attrCombobox.delegate = self;
	self.attrCombobox.view.frame = self.attrComboContainer.frame;
	
	UIView *aSuperview = self.attrComboContainer.superview;
	[self.attrComboContainer removeFromSuperview];
	[aSuperview addSubview:self.attrCombobox.view];
	[aSuperview bringSubviewToFront:self.attrCombobox.view];

	NSArray *operatorDicts = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OperatorList" ofType:@"plist"]];
	self.operCombobox = [[ComboboxController alloc] initWithDataSource:operatorDicts displayStringKeypath:@"label"];
	self.operCombobox.delegate = self;
	self.operCombobox.view.frame = self.operComboContainer.frame;
	
	aSuperview = self.operComboContainer.superview;
	[self.operComboContainer removeFromSuperview];
	[aSuperview addSubview:self.operCombobox.view];
	[aSuperview bringSubviewToFront:self.operCombobox.view];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.attrCombobox = nil;
	self.operCombobox = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (self.attrCombobox != nil) [self.attrCombobox viewWillAppear:animated];
	if (self.operCombobox != nil) [self.operCombobox viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if (self.attrCombobox != nil) [self.attrCombobox viewWillDisappear:animated];
	if (self.operCombobox != nil) [self.operCombobox viewWillDisappear:animated];
	
	NSString *predicateExpr = [NSString stringWithFormat:@"%@ %@ %@", self.attrCombobox.selectedObject, [self.operCombobox.selectedObject valueForKey:@"content"], self.valueField.text];
	NSLog(@"%s : '%@'", __PRETTY_FUNCTION__, predicateExpr);
	self.predicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:self.attrCombobox.selectedObject]
														rightExpression:[NSExpression expressionForVariable:self.valueField.text]
															   modifier:NSDirectPredicateModifier
																   type:[self operatorTypeFromString:[self.operCombobox.selectedObject valueForKey:@"content"]]
																options:NSCaseInsensitivePredicateOption | NSDiacriticInsensitivePredicateOption];
	if (self.delegate != nil) [self.delegate predicateViewController:self willCloseWithTitle:self.titleField.text andPredicate:self.predicate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	self.delegate = nil;
	self.predicate = nil;
	self.titleField = nil;
    self.attrCombobox = nil;
	self.operCombobox = nil;
}

- (NSPredicateOperatorType)operatorTypeFromString:(NSString *)operator {
	if (IS_EMPTY_STRING(operator)) return -1;
	if ([@"=" isEqualToString:operator]) return NSEqualToPredicateOperatorType;
	else if ([@"<" isEqualToString:operator]) return NSLessThanPredicateOperatorType;
	else if ([@">" isEqualToString:operator]) return NSGreaterThanPredicateOperatorType;
	else if ([@"contains" isEqualToString:operator]) return NSContainsPredicateOperatorType;
	return -1;
}

#pragma mark - Combobox delegate

- (void)comboboxController:(ComboboxController *)controller didSelectObject:(id)selectedObject {
//	NSLog(@"%s : %@", __PRETTY_FUNCTION__, selectedObject);
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
