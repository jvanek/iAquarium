//
//  Localization.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "GenericManagedObject.h"

#define LOCALIZATION_ENTITY_NAME			@"Localization"

#define LOCALIZATION_KEY_CODE				@"code"
#define LOCALIZATION_KEY_COUNTRY			@"country"

#define LOCALIZATION_REL_COMMON_NAMES		@"commonNames"


@class CommonName;

@interface Localization : GenericManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSSet *commonNames;
@end

@interface Localization (CoreDataGeneratedAccessors)

- (void)addCommonNamesObject:(CommonName *)value;
- (void)removeCommonNamesObject:(CommonName *)value;
- (void)addCommonNames:(NSSet *)values;
- (void)removeCommonNames:(NSSet *)values;

@end
