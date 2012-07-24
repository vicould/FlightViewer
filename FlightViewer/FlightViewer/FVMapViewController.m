//
//  FlightViewerSubViewMapController.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "FVMapViewController.h"
#import "RoutePoint.h"

@interface FVMapViewController ()

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) MKPolyline *fpRouteLine;
@property (nonatomic, strong) MKPolylineView *fpRouteLineView;
@property (nonatomic, strong) NSMutableDictionary *centersOverlaysMapping;

@end

@implementation FVMapViewController

@synthesize flightPoints = _flightPoints;
@synthesize flightInfo = _flightInfo;
@synthesize mapView = _mapView;
@synthesize fpRouteLine = _fpRouteLine;
@synthesize fpRouteLineView = _fpRouteLineView;
@synthesize centersOverlaysMapping = _centersOverlaysMapping;

- (NSMutableDictionary *)centersOverlaysMapping
{
    if (!_centersOverlaysMapping) {
        _centersOverlaysMapping = [NSMutableDictionary dictionary];
    }
    return _centersOverlaysMapping;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
    [self.mapView setRegion:(MKCoordinateRegion){{39.8, -98.2}, {35, 60}} animated:YES];
    
    // fp
    
    // Create a MKPolyline
    MKMapPoint* pointArr = malloc(sizeof(MKMapPoint) * self.flightPoints.count);
    
    for (int i = 0; i < self.flightPoints.count; i++) {
        RoutePoint *routePoint = [self.flightPoints objectAtIndex:i];
        
        CLLocationDegrees latitude = [routePoint.latitude doubleValue];
        CLLocationDegrees longitude = [routePoint.longitude doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        
        pointArr[i] = point;
    }
    
    self.fpRouteLine = [MKPolyline polylineWithPoints:pointArr count:self.flightPoints.count];
    free(pointArr);
    
    // Add the polyline (as a MKOverlay) to the map
    
    [self.mapView addOverlay:self.fpRouteLine];
    
    // display sectors
    [self displaySectorsInTheMap];
    
    self.title = [NSString stringWithFormat:@"Flight path from %@ to %@", self.flightInfo.airportDeparture, self.flightInfo.airportArrival];    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        [UIView beginAnimations:@"map" context:nil];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        [self.navigationController.view setTransform: CGAffineTransformMakeRotation(M_PI / 2)];
        [self.navigationController.view setFrame:CGRectMake(0, 0, 320, 480)];
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 480, 32)];
        [UIView commitAnimations];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        [UIView beginAnimations:@"map" context:nil];
        [self.navigationController.view setTransform: CGAffineTransformMakeRotation(0)];
        [self.navigationController.view setFrame:CGRectMake(0, 0, 320, 480)];
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 44)];
        [UIView commitAnimations];
    }
    [UIView setAnimationsEnabled:YES];
    [super viewWillDisappear:animated];
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
    else {
        overlayView = [self.centersOverlaysMapping objectForKey:((id<MKAnnotation>)overlay).title];
        if (overlayView) {
            if ((NSNull *)overlayView == [NSNull null] ) {
                MKPolygonView *polygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
                polygonView.strokeColor = [UIColor blackColor];
                polygonView.lineWidth = 1.0;
                overlayView = polygonView;
                [self.centersOverlaysMapping setObject:polygonView forKey:((id<MKAnnotation>)overlay).title];
            }
        }
    }
    return overlayView;
}

- (void)displaySectorsInTheMap
{
    // read file and iterate over the sectors
    NSString *centersPlistPath = [[NSBundle mainBundle] pathForResource:@"Centers" ofType:@"plist"];
    NSDictionary *centers = [NSDictionary dictionaryWithContentsOfFile:centersPlistPath];
    
    for (NSString *key in centers) {
   
        // Create a MKPolygon for 1 sector
        NSArray *centerCoordinates = [centers objectForKey:key];
        int numberOfPoints = [centerCoordinates count];
        
        CLLocationCoordinate2D *coordinatesArr = malloc(sizeof(CLLocationCoordinate2D) * numberOfPoints);
        for (int i = 0; i < numberOfPoints; i++) {
            CLLocationDegrees latitude = [[[centerCoordinates objectAtIndex:i] objectAtIndex:0] doubleValue];
            CLLocationDegrees longitude = [[[centerCoordinates objectAtIndex:i] objectAtIndex:1] doubleValue];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            coordinatesArr[i] = coordinate;
        }
        
        MKPolygon *centerPolygon = [MKPolygon polygonWithCoordinates:coordinatesArr count:numberOfPoints];
        centerPolygon.title = key;
        [self.centersOverlaysMapping setObject:[NSNull null] forKey:key];
        free(coordinatesArr);
        
        // Add the polyline (as a MKOverlay) to the map
        [self.mapView addOverlay:centerPolygon];
     }
}

- (IBAction)toggleNavigationBar:(id)sender {
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 480, 32)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return YES;
    } else {
        [UIView setAnimationsEnabled:NO];
        return NO;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [UIView setAnimationsEnabled:YES];
}

@end
