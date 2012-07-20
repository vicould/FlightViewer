//
//  FlightViewerTopViewController.h
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface FlightViewerTopViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *flightPlanDatabase;

@end
