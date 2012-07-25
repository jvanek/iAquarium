//
//  NetworkIndicatorController.m
//  BusinessTalk
//
//  Created by Vanek Josef on 02/01/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "NetworkIndicatorController.h"


@interface NetworkIndicatorController()
@property (nonatomic, assign) float minValue, maxValue, currentValue;
@end


@implementation NetworkIndicatorController

@synthesize activityIndicator;
@synthesize mainLabel, secondaryLabel;
@synthesize progressIndicator;
@synthesize showsTitle, showsSecondary, showsProgress;
@synthesize minValue, maxValue, currentValue;


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.activityIndicator.frame = CGRectMake((NETWORK_INDICATOR_SIZE - ACTIVITY_INDICATOR_SIZE) / 2.0,
											  (NETWORK_INDICATOR_SIZE - ACTIVITY_INDICATOR_SIZE) / 2.0,
											  ACTIVITY_INDICATOR_SIZE, ACTIVITY_INDICATOR_SIZE);
}

- (void)dealloc {
	[self.activityIndicator stopAnimating];
	self.activityIndicator = nil;
	self.mainLabel = nil;
	self.secondaryLabel = nil;
	self.progressIndicator = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	[self resetControls];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (UIModalTransitionStyle)modalTransitionStyle {
	return UIModalTransitionStyleCrossDissolve;
}

- (void)resetControls {
	self.mainLabel.hidden = !self.showsTitle;
	self.mainLabel.text = @"";
	self.secondaryLabel.hidden = !self.showsSecondary;
	self.secondaryLabel.text = @"";
	self.progressIndicator.hidden = !self.showsProgress;
	self.progressIndicator.progress = 0.0;
}

- (void)prepareWithMinValue:(float)aMin maxValue:(float)aMax forTitle:(NSString *)aTitle {
	self.minValue = MIN(aMin, aMax);
	self.maxValue = MAX(aMin, aMax);
	self.currentValue = self.minValue;
	self.mainLabel.text = aTitle;
}

- (void)prepareWithParameters:(NSDictionary *)params {
	float min = [[params objectForKey:PARAM_KEY_MIN_VALUE] floatValue];
	float max = [[params objectForKey:PARAM_KEY_MAX_VALUE] floatValue];
	NSString *title = [params objectForKey:PARAM_KEY_MAIN_TITLE];
	[self prepareWithMinValue:min maxValue:max forTitle:title];
}

- (void)updateWithProgress:(float)aValue secondaryText:(NSString *)aText {
	if (aValue < self.minValue) self.currentValue = self.minValue;
	else if (aValue > self.maxValue) self.currentValue = self.maxValue;
	else self.currentValue = aValue;
	float distance = fabs(self.maxValue - self.minValue);
	self.progressIndicator.progress = (distance != 0.0) ? self.currentValue / distance : 0.0;
	self.secondaryLabel.text = aText;
}

- (void)updateWithParameters:(NSDictionary *)params {
	float value = [[params objectForKey:PARAM_KEY_VALUE] floatValue];
	NSString *secondaryTitle = [params objectForKey:PARAM_KEY_SECONDARY_TITLE];
	[self updateWithProgress:value secondaryText:secondaryTitle];
}

@end
