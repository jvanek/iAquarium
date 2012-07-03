//
//  DataController.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//


#define NETWORK_DATA_DATE_FORMAT	@"yyyy-MM-dd'T'HH:mm:ss'Z'"


@interface DataController : NSObject

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

+ (DataController *)sharedInstance;
+ (NSDictionary *)mappingForEntityName:(NSString *)entityName;

- (void)updateDatabaseUsingURL:(NSURL *)remoteUrl onCompletion:(void (^)(NSError *error))completionHandler;
- (void)updateIndexes;

@end
