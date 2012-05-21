//
//  LongTextCell.h
//  AquaBase
//
//  Created by Vaněk Josef on 21/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#define LONG_TEXT_CELL_ID		@"LongTextCellID"



@interface LongTextCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel, *textLabel;

- (void)configureWithTitle:(NSString *)aTitle andText:(NSString *)aText;

@end
