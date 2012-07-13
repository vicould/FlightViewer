//
//  FlightViewerViewController.h
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightViewerFPDetail.h"

/*
 * The root controller of the application. 
 */
@interface FlightViewerViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) FlightViewerFPDetail *fpDetail;

@end
