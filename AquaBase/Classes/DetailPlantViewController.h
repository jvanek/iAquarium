//
//  DetailPlantViewController.h
//  AquaBase
//
//  Created by Josef Vanek on 27/07/12.
//  Copyright (c) 2012 Pallas Software. All rights reserved.
//

#import "DetailViewController.h"
#import "Plant.h"


#define PlantDetailCellID	@"PlantDetailCellID"


@interface DetailPlantViewController : DetailViewController

@property (strong, nonatomic) Plant *detailItem;

@end
