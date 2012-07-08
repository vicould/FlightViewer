//
//  FlightViewerSubViewMapController.h
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "FlightViewerFPDetail.h"


@interface FlightViewerSubViewMapController : UIViewController <MKMapViewDelegate>

- (id)initWithFPDetail:(FlightViewerFPDetail *)fpDetail;

@end
