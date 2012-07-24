//
//  PlistTest.m
//  LiveUp
//
//  Created by Vanek Josef on 06/10/11.
//  Copyright (c) 2011 Pallas Free Foundation. All rights reserved.
//

#import "StreamController.h"


@interface XMLParserTest : GHTestCase<StreamControllerDelegate>

@property (nonatomic, strong) StreamController *streamController;
@property (nonatomic, strong) NSArray *allowedElementNames;

@end



@implementation XMLParserTest

@synthesize streamController;
@synthesize allowedElementNames;

- (void)setUp {
}

- (void)tearDown {
}

- (void)setUpClass {
	self.allowedElementNames = [NSArray arrayWithObjects:@"poissons", @"poisson", @"NomScientifique", @"NomCommuns", @"NomCommun", @"Descripteur",
								@"Famille", @"Temperature", @"TempMin", @"TempMax", @"TempRepro", @"Acidite", @"PHMin", @"PHMax", @"PHRepro",
								@"Durete", @"GHMin", @"GHMax", @"GHRepro", @"Taille", @"TailleMale", @"TailleFemelle", @"EsperanceVie", @"ZoneDeVie",
								@"Origine", @"Description", @"Dimorphisme", @"Comportement", @"Reproduction", nil];
}

- (void)tearDownClass {
	self.allowedElementNames = nil;
	self.streamController = nil;
}

#pragma mark - StreamControllerDelegate methods

- (id)xmlReaderItem {
	return [NSMutableDictionary dictionary];
}

- (NSString *)xmlReaderItemElementName {
	return @"poisson";
}

- (BOOL)xmlReaderIsValidParsingElementName:(NSString *)elementName {
	return [self.allowedElementNames containsObject:elementName];
}

- (void)xmlReaderParsedString:(NSString *)content forElementName:(NSString *)elementName {
	
}

#pragma mark - Test methods

- (void)test_1_ParseFish {
	NSError *error = nil;
	NSURL *streamUrl = [[NSBundle mainBundle] URLForResource:@"poissons-aquarium" withExtension:@"xml"];
	GHAssertNotNil(streamUrl, @"The xml file cannot be found");
	
	self.streamController = [[StreamController alloc] init];
	self.streamController.delegate = self;
	BOOL result = [self.streamController parseXmlFromUrl:streamUrl error:&error];
	GHAssertTrue(result, @"Error when parsing xml stream : %@", [error localizedDescription]);
}

- (void)test_2_ParsePlants {
	NSError *error = nil;
	NSURL *streamUrl = [[NSBundle mainBundle] URLForResource:@"plantes-aquarium" withExtension:@"xml"];
	GHAssertNotNil(streamUrl, @"The xml file cannot be found");
	
	self.streamController = [[StreamController alloc] init];
	self.streamController.delegate = self;
	BOOL result = [self.streamController parseXmlFromUrl:streamUrl error:&error];
	GHAssertTrue(result, @"Error when parsing xml stream : %@", [error localizedDescription]);
}

@end
