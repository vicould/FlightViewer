//
//  FlightViewerSubViewMapController.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlightViewerSubViewMapController.h"
#import "FlightViewerSubViewPath.h"

@interface FlightViewerSubViewMapController ()

@property (nonatomic, strong) FlightViewerFPDetail *fpDetail;

@end

@implementation FlightViewerSubViewMapController

@synthesize fpDetail = _fpDetail;

- (id)initWithFPDetail:(FlightViewerFPDetail *)fpDetail
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.fpDetail = fpDetail;
        
        // Create subview V1
        MKMapView *map = [[MKMapView alloc] init];
        map.zoomEnabled = NO;
        map.scrollEnabled = YES;
        map.mapType = MKMapTypeStandard;
        
        self.view = map;
        FlightViewerSubViewPath *subView = [[FlightViewerSubViewPath alloc] init];
        subView.longitude = [self.fpDetail.longitude copy];
        subView.latitude = [self.fpDetail.latitude copy];
        subView.flightPlan = [self.fpDetail.flightPlan copy];
        
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
