//
//  FlightViewerSubViewMapController.h
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "FlightInfo.h"


@interface FlightViewerSubViewMapController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) NSArray *flightPoints;
@property (nonatomic, strong) FlightInfo *flightInfo;

@end
