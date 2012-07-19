//
//  FlightInfo.h
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RoutePoint;

@interface FlightInfo : NSManagedObject

@property (nonatomic, retain) NSString * acFlightId;
@property (nonatomic, retain) NSString * acType;
@property (nonatomic, retain) NSString * airportDeparture;
@property (nonatomic, retain) NSString * airportArrival;
@property (nonatomic, retain) NSDate * departureTime;
@property (nonatomic, retain) NSDate * arrivalTime;
@property (nonatomic, retain) NSString * flightPlan;
@property (nonatomic, retain) NSSet *flightInfo;
@end

@interface FlightInfo (CoreDataGeneratedAccessors)

- (void)addFlightInfoObject:(RoutePoint *)value;
- (void)removeFlightInfoObject:(RoutePoint *)value;
- (void)addFlightInfo:(NSSet *)values;
- (void)removeFlightInfo:(NSSet *)values;

@end
