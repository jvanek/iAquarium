//
//  SearchCriterium.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Intellicore. All rights reserved.
//


@interface SearchCriterium : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSComparisonPredicate *predicate;

+ (SearchCriterium *)searchCriterium;
+ (SearchCriterium *)searchCriteriumWithTitle:(NSString *)aTitle;
+ (SearchCriterium *)searchCriteriumWithTitle:(NSString *)aTitle andPredicate:(NSComparisonPredicate *)aPredicate;

@end
