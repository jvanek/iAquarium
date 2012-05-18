//
//  NetworkIndicatorController.h
//  BusinessTalk
//
//  Created by Vanek Josef on 02/01/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#define NETWORK_INDICATOR_SIZE		192.0
#define ACTIVITY_INDICATOR_SIZE		64.0

#define PARAM_KEY_MIN_VALUE			@"minValue"
#define PARAM_KEY_MAX_VALUE			@"maxValue"
#define PARAM_KEY_VALUE				@"value"
#define PARAM_KEY_MAIN_TITLE		@"mainTitle"
#define PARAM_KEY_SECONDARY_TITLE	@"secondaryTitle"


@interface NetworkIndicatorController : UIViewController

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *mainLabel, *secondaryLabel;
@property (nonatomic, strong) IBOutlet UIProgressView *progressIndicator;
@property (nonatomic, assign) BOOL showsTitle, showsSecondary, showsProgress;

- (void)resetControls;
- (void)prepareWithMinValue:(float)aMin maxValue:(float)aMax forTitle:(NSString *)aTitle;
- (void)prepareWithParameters:(NSDictionary *)params;
- (void)updateWithProgress:(float)aValue secondaryText:(NSString *)aText;
- (void)updateWithParameters:(NSDictionary *)params;

@end
