//
//  FlightViewerFPDetail.h
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlightViewerFPDetail : NSObject

@property (readonly, strong) NSArray *altitude;
@property (readonly, strong) NSArray *speed;
@property (readonly, strong) NSArray *time;
@property (readonly, strong) NSArray *longitude;
@property (readonly, strong) NSArray *latitude;
@property (readonly, strong) NSString *flightPlan;

@end
