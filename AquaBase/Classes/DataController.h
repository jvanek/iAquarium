//
//  DataController.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "StreamController.h"


#define NETWORK_DATA_DATE_FORMAT	@"yyyy-MM-dd'T'HH:mm:ss'Z'"


@interface DataController : NSObject<StreamControllerDelegate>

@property (nonatomic, strong) StreamController *streamController;
@property (nonatomic, strong) NSArray *allowedElementNames;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

+ (DataController *)sharedInstance;
+ (NSDictionary *)mappingForEntityName:(NSString *)entityName;

- (BOOL)updateDatabaseUsingURL:(NSURL *)remoteUrl error:(NSError **)error;

@end
