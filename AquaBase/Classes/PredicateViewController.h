//
//  PredicateViewController.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

@class PredicateViewController;

@protocol PredicateViewControllerDelegate <NSObject>

- (void)predicateViewController:(PredicateViewController *)controller willCloseWithTitle:(NSString *)aTitle andPredicate:(NSComparisonPredicate *)aPredicate;

@end



@interface PredicateViewController : UIViewController

@property (nonatomic, strong) NSComparisonPredicate *predicate;
@property (nonatomic, weak) id<PredicateViewControllerDelegate> delegate;

@end
