//
//  StreamController.m
//  AquaBase
//
//  Created by Vaněk Josef on 10/05/12.
//  Copyright (c) 2012 Pallas Free Foundation. All rights reserved.
//

#import "StreamController.h"


@interface StreamController()

@property (nonatomic, assign) NSUInteger parsedCounter;
@property (nonatomic, strong) NSMutableString *contentOfCurrentProperty;
@property (nonatomic, strong) id currentObject;

- (void)setup;

@end



@implementation StreamController

@synthesize xmlParser;
@synthesize parsedCounter;
@synthesize contentOfCurrentProperty;
@synthesize delegate;
@synthesize currentObject;

/*
+ (StreamController *)sharedInstance { 
    static dispatch_once_t pred = 0; 
    __strong static StreamController *_sharedDataObject = nil;
    dispatch_once(&pred, ^{
		_sharedDataObject = [self new];
		[_sharedDataObject setup];
    });	
    return _sharedDataObject;
}
*/

- (id)init {
	if ((self = [super init]) != nil) {
		[self setup];
	}
	return self;
}

- (void)dealloc {
	self.xmlParser = nil;
	self.contentOfCurrentProperty = nil;
	self.delegate = nil;
	self.currentObject = nil;
}

- (void)setup {
	self.xmlParser = nil;
	self.parsedCounter = 0;
}

- (BOOL)parseXmlFromUrl:(NSURL *)streamUrl error:(NSError **)error {
	BOOL result = YES;
	self.parsedCounter = 0;
	self.xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:streamUrl];

    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    self.xmlParser.delegate = self;
	
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    self.xmlParser.shouldProcessNamespaces = YES;
    self.xmlParser.shouldReportNamespacePrefixes = NO;
    self.xmlParser.shouldResolveExternalEntities = YES;
    
    [self.xmlParser parse];
    
    NSError *parseError = self.xmlParser.parserError;
    if (parseError != nil) {
		result = NO;
		if (error != nil) {
			*error = parseError;
		}
		NSLog(@"%s : Parse Error : %@\nat line %d and column %d", __PRETTY_FUNCTION__, [parseError localizedDescription], self.xmlParser.lineNumber, self.xmlParser.columnNumber);
    }
#ifdef DEBUG_XML
    NSLog(@"%s : Parsed %d items", __PRETTY_FUNCTION__, parsedCounter);
#endif

	return result;
}

#pragma mark - NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }
#ifdef DEBUG_XML
    NSLog(@"%s : ParserDidStartElement: %@", __PRETTY_FUNCTION__, qName);
#endif
	
    // If the number of parsed Newss is greater than MAX_ELEMENTS, abort the parse.
    // Otherwise the application runs very slowly on the device.
	//    if (parsedNewssCounter >= MAX_NewsS) {
	//        [parser abortParsing];
	//    }
    
    if ([elementName isEqualToString:[self.delegate xmlReaderItemElementName]]) {        
        // parsedCounter++;		
        self.currentObject = [self.delegate xmlReaderItem];
		
		/*		Il est peut-etre preferable d'ajouter l'objet qu'a la fin, lorsque tous ses noeuds on tete parses
		 avec succes...
		 if ([self.delegate respondsToSelector:@selector(xmlReaderAddToList:)]) {
		 [self.delegate xmlReaderAddToList:self.currentObject];
		 }
		 */
    } else {
		if ([self.delegate xmlReaderIsValidParsingElementName:elementName]) {
			// Create a mutable string to hold the contents of the element.
			// The contents are collected in parser:foundCharacters:.
			self.contentOfCurrentProperty = [NSMutableString string];
		} else {
			// The element isn't one that we care about, so set the property that holds the 
			// character content of the current element to nil. That way, in the parser:foundCharacters:
			// callback, the string that the parser reports will be ignored.
			self.contentOfCurrentProperty = nil;
		}
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{     
    if (qName) {
        elementName = qName;
    }
#ifdef DEBUG_XML
    NSLog(@"%s : ParserDidEndElement: %@", __PRETTY_FUNCTION__, qName);
#endif
	
    if ([elementName isEqualToString:[self.delegate xmlReaderItemElementName]]) {        
        parsedCounter++;
		if ([self.delegate respondsToSelector:@selector(xmlReaderAddToList:)]) {
			[self.delegate xmlReaderAddToList:self.currentObject];
		}		
    } else {
		if ([self.delegate xmlReaderIsValidParsingElementName:elementName]) {
			[self.delegate xmlReaderParsedString:self.contentOfCurrentProperty
								  forElementName:elementName];
		}
	}
}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{
    if (self.contentOfCurrentProperty) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        [self.contentOfCurrentProperty appendString:string];
    }
}

@end
