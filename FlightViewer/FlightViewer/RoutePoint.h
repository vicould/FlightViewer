//
//  RoutePoint.h
//  FlightViewer
//
//  Created by Ludovic Delaveau on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FlightInfo;

@interface RoutePoint : NSManagedObject

@property (nonatomic, retain) NSNumber * altitude;
@property (nonatomic, retain) NSNumber * fid;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) FlightInfo *whoFlown;

@end
