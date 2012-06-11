//
//  ComboboxController.h
//  AquaBase
//
//  Created by Vaněk Josef on 04/06/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#define DEFAULT_ROW_HEIGHT		32.0
#define BUTTON_WIDTH			30.0

@class ComboboxController;

@protocol ComboboxControllerDelegate <NSObject>

- (void)comboboxController:(ComboboxController *)controller didSelectObject:(id)selectedObject;

@end



@interface ComboboxController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *selectionLabel;
@property (nonatomic, weak) id<ComboboxControllerDelegate> delegate;
@property (nonatomic, weak) id selectedObject;

- (id)initWithDataSource:(NSArray *)dataSource displayStringKeypath:(NSString *)keypath;

- (IBAction)toggleSelectionList:(UIButton *)sender;

@end
