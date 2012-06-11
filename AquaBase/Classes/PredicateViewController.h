//
//  PredicateViewController.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "ComboboxController.h"

@class PredicateViewController;

@protocol PredicateViewControllerDelegate <NSObject>

- (void)predicateViewController:(PredicateViewController *)controller willCloseWithTitle:(NSString *)aTitle andPredicate:(NSPredicate *)aPredicate;

@end



@interface PredicateViewController : UIViewController<ComboboxControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, weak) id<PredicateViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIView *attrComboContainer, *operComboContainer;
@property (nonatomic, weak) IBOutlet UITextField *valueField;
@property (nonatomic, weak) IBOutlet UITextField *titleField;

@end
