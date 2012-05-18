//
//  GenericManagedObject.m
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "GenericManagedObject.h"
#import "DataController.h"
#import "NSManagedObjectContext+Additions.h"


@implementation GenericManagedObject

+ (GenericManagedObject *)updateObjectForKey:(NSString *)aKey
									   value:(id)aValue
								  entityName:(NSString *)entityName
							  fromDictionary:(NSDictionary *)aDict
						   orCreateInContext:(NSManagedObjectContext *)ctx {
	// Very time-consuming method
	GenericManagedObject *result = (GenericManagedObject *)[ctx objectForEntityNamed:entityName matchingKey:aKey value:aValue];
	if (result == nil) {
		result = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:ctx];
	}
	[result replaceWithDictionary:aDict];	
	return result;
}

+ (GenericManagedObject *)createObjectWithDictionary:(NSDictionary *)aDict
										  entityName:(NSString *)entityName
										   inContext:(NSManagedObjectContext *)ctx {
	GenericManagedObject *result = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:ctx];
	[result replaceWithDictionary:aDict];
	return result;
}

+ (GenericManagedObject *)objectForKey:(NSString *)aKey
								 value:(id)aValue
							entityName:(NSString *)entityName
							 inContext:(NSManagedObjectContext *)ctx {
	// Very time-consuming method
	return (GenericManagedObject *)[ctx objectForEntityNamed:entityName matchingKey:aKey value:aValue];
}

+ (GenericManagedObject *)safeCreateObjectForKey:(NSString *)aKey
										   value:(id)aValue
									  entityName:(NSString *)entityName
								  fromDictionary:(NSDictionary *)aDict
									   inContext:(NSManagedObjectContext *)ctx {
	GenericManagedObject *object = [GenericManagedObject objectForKey:aKey value:aValue entityName:entityName inContext:ctx];
	if (object == nil) {
		object = [GenericManagedObject createObjectWithDictionary:aDict entityName:entityName inContext:ctx];
	}
	return object;
}

/*!
 * Must be overridden by subclasses
 */
- (NSArray *)attributeKeys {
	return nil;
}

/*!
 * Can be overridden by subclasses
 */
- (NSString *)entityName {
	return [self.entity name];
}

+ (NSString *)mappedKeyForKey:(NSString *)aKey inEntityName:(NSString *)entityName {
	NSDictionary *attributeMapping = [DataController mappingForEntityName:entityName];
	NSString *mappedKey = (attributeMapping != nil) ? [attributeMapping objectForKey:aKey] : aKey;
	if (mappedKey == nil) mappedKey = aKey;
	return mappedKey;	
}

+ (NSArray *)mappedKeysForKeys:(NSArray *)keys inEntityName:(NSString *)entityName {
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:[keys count]];
	for (NSString *oldKey in keys) [result addObject:[GenericManagedObject mappedKeyForKey:oldKey inEntityName:entityName]];
	return result;
}

+ (id)objectForMappedKey:(NSString *)aKey inEntityName:(NSString *)entityName fromDictionary:(NSDictionary *)aDict {
	NSString *mappedKey = [GenericManagedObject mappedKeyForKey:aKey inEntityName:entityName];
	return [aDict objectForKey:mappedKey];	
}

- (NSString *)mappedKeyForKey:(NSString *)aKey {
	return [GenericManagedObject mappedKeyForKey:aKey inEntityName:self.entityName];
}

- (NSArray *)mappedKeysForKeys:(NSArray *)keys {
	return [GenericManagedObject mappedKeysForKeys:keys inEntityName:self.entityName];
}

- (id)objectForMappedKey:(NSString *)aKey fromDictionary:(NSDictionary *)aDict {
	return [GenericManagedObject objectForMappedKey:aKey inEntityName:self.entityName fromDictionary:aDict];
}

- (BOOL)isNullString:(id)aValue {
	return ([aValue isKindOfClass:[NSString class]] && [(NSString *)aValue rangeOfString:@"Null" options:NSCaseInsensitiveSearch].location != NSNotFound);
}

- (void)setValuesFromDictionary:(NSDictionary *)aDict mappedAttributes:(BOOL)usingMapped replace:(BOOL)replace {
	if (aDict != nil) {
		id aValue = nil;
		for (NSString *aKey in self.attributeKeys) {
			aValue = usingMapped ? [self objectForMappedKey:aKey fromDictionary:aDict] : [aDict objectForKey:aKey];
			if ([self isNullString:aValue]) [self setValue:nil forKey:aKey];
			else if (aValue != nil) [self setValue:aValue forKey:aKey];
			else if (replace) [self setValue:aValue forKey:aKey];
		}
	}	
}

- (void)replaceWithDictionary:(NSDictionary *)aDict usingMappedAttributes:(BOOL)usingMapped {
	[self setValuesFromDictionary:aDict mappedAttributes:usingMapped replace:YES];
}

- (void)replaceWithDictionary:(NSDictionary *)aDict {
	[self replaceWithDictionary:aDict usingMappedAttributes:YES];
}

- (void)updateWithDictionary:(NSDictionary *)aDict usingMappedAttributes:(BOOL)usingMapped {
	[self setValuesFromDictionary:aDict mappedAttributes:usingMapped replace:NO];
}

- (void)updateWithDictionary:(NSDictionary *)aDict {
	[self updateWithDictionary:aDict usingMappedAttributes:YES];
}

- (NSNumber *)intValueFromObject:(id)objValue {
	NSNumber *result = nil;
	if (objValue != nil) {
		if ([objValue isKindOfClass:[NSNumber class]]) result = objValue;
		else if ([objValue isKindOfClass:[NSString class]] &&
				 [(NSString *)objValue rangeOfString:@"Null" options:NSCaseInsensitiveSearch].location == NSNotFound)
			result = [NSNumber numberWithInt:[(NSString *)objValue intValue]];
	}
	return result;
}

- (NSNumber *)floatValueFromObject:(id)objValue {
	NSNumber *result = nil;
	if (objValue != nil) {
		if ([objValue isKindOfClass:[NSNumber class]]) result = objValue;
		else if ([objValue isKindOfClass:[NSString class]] &&
				 [(NSString *)objValue rangeOfString:@"Null" options:NSCaseInsensitiveSearch].location == NSNotFound)
			result = [NSNumber numberWithFloat:[(NSString *)objValue floatValue]];
	}
	return result;
}

- (NSDate *)dateValueFromObject:(id)objValue {
	NSDate *result = nil;
	if (objValue != nil) {
		if ([objValue isKindOfClass:[NSDate class]]) result = (NSDate *)objValue;
		else if ([objValue isKindOfClass:[NSString class]] &&
				 [(NSString *)objValue rangeOfString:@"Null" options:NSCaseInsensitiveSearch].location == NSNotFound)
			result = [[DataController sharedInstance].dateFormatter dateFromString:(NSString *)objValue];
	}
	return result;
}

@end
