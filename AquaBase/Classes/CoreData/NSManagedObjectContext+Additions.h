//
//  NSManagedObjectContext+Additions.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Additions)

- (id)objectForEntityNamed:(NSString *)entityName matchingKey:(NSString *)aKey value:(id)aValue;

@end
