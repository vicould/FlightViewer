//
//  FlightViewerSubViewMapController.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "FlightViewerSubViewMapController.h"
#import "FlightViewerSubViewPath.h"


@interface FlightViewerSubViewMapController ()

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@end

@implementation FlightViewerSubViewMapController

@synthesize fpDetail = _fpDetail;
@synthesize mapView = _mapView;

- (id)initWithFPDetail:(FlightViewerFPDetail *)fpDetail
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.fpDetail = fpDetail;
        
        // Create subview V1
//        MKMapView *map = [[MKMapView alloc] init];
//        map.zoomEnabled = NO;
//        map.scrollEnabled = YES;
//        map.mapType = MKMapTypeStandard;
//        
//        MKCoordinateSpan span = MKCoordinateSpanMake(0.4, 0.4);
//        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(37.779, -122.419);
//        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
//        [map setRegion:region animated:YES];
//        self.view = map;
//        
//        FlightViewerSubViewPath *subView = [[FlightViewerSubViewPath alloc] init];
//        subView.longitude = [self.fpDetail.longitude copy];
//        subView.latitude = [self.fpDetail.latitude copy];
//        subView.flightPlan = [self.fpDetail.flightPlan copy];
        
        
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
    [self.mapView setRegion:(MKCoordinateRegion){{39.8, -98.2}, {35, 60}} animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
