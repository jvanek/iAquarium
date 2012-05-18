//
//  XmlParsingOperation.h
//  AquaBase
//
//  Created by Vaněk Josef on 18/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "StreamController.h"


@interface XmlParsingOperation : NSOperation<StreamControllerDelegate>

@property (nonatomic, strong) StreamController *streamController;
@property (nonatomic, strong) NSArray *allowedElementNames;
@property (nonatomic, copy) void (^completionHandler)(void);

- (id)initWithURL:(NSURL *)anUrl;

@end
