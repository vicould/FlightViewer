//
//  FlightInfo.h
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Airline, RoutePoint;

@interface FlightInfo : NSManagedObject

@property (nonatomic, retain) NSString * acFlightId;
@property (nonatomic, retain) NSString * acType;
@property (nonatomic, retain) NSString * airportArrival;
@property (nonatomic, retain) NSString * airportDeparture;
@property (nonatomic, retain) NSDate * arrivalTime;
@property (nonatomic, retain) NSDate * departureTime;
@property (nonatomic, retain) NSNumber * fid;
@property (nonatomic, retain) NSString * flightPlan;
@property (nonatomic, retain) NSString * airline;
@property (nonatomic, retain) NSSet *flightInfo;
@property (nonatomic, retain) Airline *whoBelongs;
@end

@interface FlightInfo (CoreDataGeneratedAccessors)

- (void)addFlightInfoObject:(RoutePoint *)value;
- (void)removeFlightInfoObject:(RoutePoint *)value;
- (void)addFlightInfo:(NSSet *)values;
- (void)removeFlightInfo:(NSSet *)values;

@end
