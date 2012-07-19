//
//  RoutePoint.h
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FlightInfo;

@interface RoutePoint : NSManagedObject

@property (nonatomic, retain) NSNumber * altitude;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) FlightInfo *whoFlown;

@end
