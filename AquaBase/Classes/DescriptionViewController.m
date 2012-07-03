//
//  DescriptionViewController.m
//  AquaBase
//
//  Created by Vanek Josef on 03/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()

@property (nonatomic, strong) NSString *htmlContent;
@property (nonatomic, strong) NSMutableString *htmlTemplate;

- (NSString *)htmliseContent:(NSString *)aContent;
- (NSString *)htmlWithContent:(NSString *)aContent;

@end



@implementation DescriptionViewController

@synthesize contentView, htmlContent;
@synthesize htmlTemplate = _htmlTemplate;

// viewDidLoad is called AFTER prepareForSegue in the originating controller
// thus we cannot use it here to initialize variables and other stuff
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.contentView.delegate = nil;
    self.contentView = nil;
	self.htmlContent = nil;
	self.htmlTemplate = nil;
}

- (void)dealloc {
	self.contentView.delegate = nil;
    self.contentView = nil;
	self.htmlContent = nil;
	self.htmlTemplate = nil;
}

- (NSMutableString *)htmlTemplate {
	NSError *err = nil;
	if (_htmlTemplate == nil) {
		NSMutableString *template = nil;
		NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"DescriptionTemplate" ofType:@"html"];
		template = [NSMutableString stringWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:&err];
		if (!IS_EMPTY_STRING(template)) _htmlTemplate = template;
		else LOG(@"Unable to load html template");
	}
	return _htmlTemplate;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.contentView loadHTMLString:self.htmlContent baseURL:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)htmliseContent:(NSString *)aContent {
	NSMutableString *result = [NSMutableString stringWithString:aContent];
	NSRange searchRange = NSMakeRange(0, [result length]);
	[result replaceOccurrencesOfString:@"\n" withString:@"<br/>" options:NSCaseInsensitiveSearch range:searchRange];
	return result;
}

- (NSString *)htmlWithContent:(NSString *)aContent {
	NSMutableString *result = nil;
	if (!IS_EMPTY_STRING(self.htmlTemplate)) {
		result = self.htmlTemplate;
		NSRange contentRange = [result rangeOfString:@"//--CONTENT--//"];
		if (contentRange.location != NSNotFound) [result replaceCharactersInRange:contentRange withString:[self htmliseContent:aContent]];
	}
	return result;
}

- (void)setupWithTitle:(NSString *)aTitle andContent:(NSString *)aContent {
	self.navigationItem.title = aTitle;
	self.htmlContent = [self htmlWithContent:aContent];
}

#pragma mark - UIWebView delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	LOG(@"An error occured while loading content: %@", [error localizedDescription]);
}

@end
