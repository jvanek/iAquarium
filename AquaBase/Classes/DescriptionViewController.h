//
//  DescriptionViewController.h
//  AquaBase
//
//  Created by Vanek Josef on 03/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//


@interface DescriptionViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *contentView;

- (void)setupWithTitle:(NSString *)aTitle andContent:(NSString *)aContent;

@end
