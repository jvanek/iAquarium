//
//  SearchViewControllerCell.m
//  AquaBase
//
//  Created by Vaněk Josef on 10/05/12.
//  Copyright (c) 2012 Intellicore. All rights reserved.
//

#import "SearchViewControllerCell.h"



@implementation SearchViewControllerCell

@synthesize mainTitleLabel, addCellButton, removeCellButton;
@synthesize criterium;

- (void)dealloc {
	self.mainTitleLabel = nil;
	self.addCellButton = nil;
	self.removeCellButton = nil;
	self.criterium = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithCriterium:(SearchCriterium *)aCriterium {
	self.criterium = aCriterium;
	self.mainTitleLabel.text = aCriterium.title;
}

@end
