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
@property (nonatomic, strong) MKPolyline *fpRouteLine;
@property (nonatomic, strong) MKPolylineView *fpRouteLineView;

@end

@implementation FlightViewerSubViewMapController

@synthesize fpDetail = _fpDetail;
@synthesize mapView = _mapView;
@synthesize fpRouteLine = _fpRouteLine;
@synthesize fpRouteLineView = _fpRouteLineView;

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
    
    // fp
    
    // Create a MKPolyline
    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * self.fpDetail.latitude.count);
    
    for (int i = 0; i<self.fpDetail.latitude.count; i++) {
        CLLocationDegrees latitude = [[self.fpDetail.latitude objectAtIndex:i] doubleValue];
        CLLocationDegrees longitude = [[self.fpDetail.longitude objectAtIndex:i] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        
        pointArr[i] = point;
    }
    
    self.fpRouteLine = [MKPolyline polylineWithPoints:pointArr count:self.fpDetail.latitude.count];
    free(pointArr);
    
    // Add the polyline (as a MKOverlay) to the map
    
    [self.mapView addOverlay:self.fpRouteLine];
    
    
}

// Implement mapView:viewForOverlay: in your MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay
{
    MKOverlayView* overlayView = nil;
    
    if (overlay == self.fpRouteLine) {
        //if we have not yet created an overlay view for this overlay, create it now.
        // Initialize, set values on, and return a MKPolylineView from your updated map view delegate
        if (nil == self.fpRouteLineView) {
            self.fpRouteLineView = [[MKPolylineView alloc] initWithPolyline:self.fpRouteLine];
            self.fpRouteLineView.strokeColor = [UIColor redColor];
            self.fpRouteLineView.lineWidth = 2.0;
        }
        overlayView = self.fpRouteLineView;
    }
    return overlayView;
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
