//
//  SearchViewControllerCell.h
//  AquaBase
//
//  Created by Vaněk Josef on 10/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "SearchCriterium.h"


#define SearchViewControllerCellID		@"SearchViewControllerCellID"
#define SearchViewControllerCellHeight	44.0

@interface SearchViewControllerCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *mainTitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *addCellButton;
@property (nonatomic, strong) IBOutlet UIButton *removeCellButton;
@property (nonatomic, strong) SearchCriterium *criterium;

- (void)updateWithCriterium:(SearchCriterium *)aCriterium;

@end
