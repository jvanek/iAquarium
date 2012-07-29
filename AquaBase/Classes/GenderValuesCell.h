//
//  GenderValuesCell.h
//  AquaBase
//
//  Created by Josef Vanek on 29/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "GenderValues.h"


#define GENDER_VALUES_CELL_ID		@"GenderValuesCellID"


@interface GenderValuesCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *maleValue, *femaleValue, *keyTitle;

- (void)configureWithGenderValues:(GenderValues *)aValues forTitle:(NSString *)aTitle;

@end
