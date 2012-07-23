//
//  FlightViewerViewController.h
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightInfo.h"

/*
 * The root controller of the application. 
 */
@interface FVFlightPlanDetailViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) FlightInfo *flightInfo;
@property (nonatomic, strong) UIManagedDocument *flightDatabase;

@end
