//
//  Airline.h
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FlightInfo;

@interface Airline : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *airline;
@end

@interface Airline (CoreDataGeneratedAccessors)

- (void)addAirlineObject:(FlightInfo *)value;
- (void)removeAirlineObject:(FlightInfo *)value;
- (void)addAirline:(NSSet *)values;
- (void)removeAirline:(NSSet *)values;

@end
