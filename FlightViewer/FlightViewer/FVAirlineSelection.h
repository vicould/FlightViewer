//
//  FVAirlineSelection.h
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataTableViewController.h"


@interface FVAirlineSelection : CoreDataTableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) UIManagedDocument *flightsDatabase;

@end
