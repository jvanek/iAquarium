//
//  LifeValuesCell.h
//  AquaBase
//
//  Created by Vaněk Josef on 21/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "LifeValues.h"


#define LIFE_VALUES_CELL_ID		@"LifeValuesCellID"


@interface LifeValuesCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *minValue, *maxValue, *reproValue, *keyTitle;

- (void)configureWithLifeValues:(LifeValues *)aValues forTitle:(NSString *)aTitle;

@end
