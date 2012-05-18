//
//  GenericManagedObject.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//


@interface GenericManagedObject : NSManagedObject

@property (nonatomic, readonly) NSArray *attributeKeys;
@property (nonatomic, readonly) NSString *entityName;

/*!
 * Creates the object if it doesn't exist and updates it with the dictionary
 */
+ (GenericManagedObject *)updateObjectForKey:(NSString *)aKey
									   value:(id)aValue
								  entityName:(NSString *)entityName
							  fromDictionary:(NSDictionary *)aDict
						   orCreateInContext:(NSManagedObjectContext *)ctx;

/*!
 * Creates the object and updates it with the dictionary without any check
 */
+ (GenericManagedObject *)createObjectWithDictionary:(NSDictionary *)aDict
										  entityName:(NSString *)entityName
										   inContext:(NSManagedObjectContext *)ctx;

/*!
 * Simply tries to fetch the object given its attribute, value and entity name
 */
+ (GenericManagedObject *)objectForKey:(NSString *)aKey
								 value:(id)aValue
							entityName:(NSString *)entityName
							 inContext:(NSManagedObjectContext *)ctx;

/*!
 * Creates AND updates the object only if it doesn't exist, otherwise the object
 * is returned as fetched without modification
 */
+ (GenericManagedObject *)safeCreateObjectForKey:(NSString *)aKey
										   value:(id)aValue
									  entityName:(NSString *)entityName
								  fromDictionary:(NSDictionary *)aDict
									   inContext:(NSManagedObjectContext *)ctx;

+ (id)objectForMappedKey:(NSString *)aKey inEntityName:(NSString *)entityName fromDictionary:(NSDictionary *)aDict;
+ (NSString *)mappedKeyForKey:(NSString *)aKey inEntityName:(NSString *)entityName;
+ (NSArray *)mappedKeysForKeys:(NSArray *)keys inEntityName:(NSString *)entityName;

- (NSString *)mappedKeyForKey:(NSString *)aKey;
- (NSArray *)mappedKeysForKeys:(NSArray *)keys;
- (id)objectForMappedKey:(NSString *)aKey fromDictionary:(NSDictionary *)aDict;
- (BOOL)isNullString:(id)aValue;
- (void)replaceWithDictionary:(NSDictionary *)aDict usingMappedAttributes:(BOOL)usingMapped;
- (void)replaceWithDictionary:(NSDictionary *)aDict;
- (void)updateWithDictionary:(NSDictionary *)aDict usingMappedAttributes:(BOOL)usingMapped;
- (void)updateWithDictionary:(NSDictionary *)aDict;

- (NSNumber *)intValueFromObject:(id)objValue;
- (NSNumber *)floatValueFromObject:(id)objValue;
- (NSDate *)dateValueFromObject:(id)objValue;

@end
