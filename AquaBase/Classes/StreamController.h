//
//  StreamController.h
//  AquaBase
//
//  Created by Vaněk Josef on 10/05/12.
//  Copyright (c) 2012 Intellicore. All rights reserved.
//

@protocol StreamControllerDelegate <NSObject>

- (id)xmlReaderItem;
- (NSString *)xmlReaderItemElementName;
- (BOOL)xmlReaderIsValidParsingElementName:(NSString *)elementName;
- (void)xmlReaderParsedString:(NSString *)content forElementName:(NSString *)elementName;

@optional
- (void)xmlReaderAddToList:(id)object;

@end



@interface StreamController : NSObject<NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, weak) id<StreamControllerDelegate> delegate;

//+ (StreamController *)sharedInstance;

- (BOOL)parseXmlFromUrl:(NSURL *)streamUrl error:(NSError **)error;

@end
