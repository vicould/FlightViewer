//
//  FlightViewerSubViewFlightInfoController.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlightViewerSubViewFlightInfoController.h"


@interface FlightViewerSubViewFlightInfoController ()

@property (weak, nonatomic) IBOutlet UILabel *acFlightId;
@property (weak, nonatomic) IBOutlet UILabel *acType;
@property (weak, nonatomic) IBOutlet UILabel *airportDeparture;
@property (weak, nonatomic) IBOutlet UILabel *departureTime;
@property (weak, nonatomic) IBOutlet UILabel *airportArrival;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTime;
@property (weak, nonatomic) IBOutlet UILabel *routeFP;

@end

@implementation FlightViewerSubViewFlightInfoController

@synthesize fpDetail = _fpDetail;


@synthesize acFlightId = _acFlightId;
@synthesize acType = _acType;
@synthesize airportDeparture = _airportDeparture;
@synthesize departureTime = _departureTime;
@synthesize airportArrival = _airportArrival;
@synthesize arrivalTime = _arrivalTime;
@synthesize routeFP = _routeFP;

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
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    // Do any additional setup after loading the view from its nib.
    self.acFlightId.text = self.fpDetail.acFlightId;
    self.acType.text = self.fpDetail.acType;
    self.airportDeparture.text = self.fpDetail.airportDeparture;
    self.departureTime.text = self.fpDetail.departureTime;
    self.airportArrival.text = self.fpDetail.airportArrival;
    self.arrivalTime.text = self.fpDetail.arrivalTime;
    self.routeFP.text = self.fpDetail.flightPlan;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        [UIView beginAnimations:@"info" context:nil];
        [self.navigationController.view setTransform: CGAffineTransformMakeRotation(M_PI / 2)];
        [self.navigationController.view setFrame:CGRectMake(0, 0, 320, 480)];
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 480, 32)];
        [UIView commitAnimations];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        [UIView beginAnimations:@"info" context:nil];
        [self.navigationController.view setTransform: CGAffineTransformMakeRotation(0)];
        [self.navigationController.view setFrame:CGRectMake(0, 0, 320, 480)];
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 44)];
        [UIView commitAnimations];
    }
}

- (void)viewDidUnload
{
    [self setAcFlightId:nil];
    [self setAcType:nil];
    [self setAirportDeparture:nil];
    [self setDepartureTime:nil];
    [self setAirportArrival:nil];
    [self setArrivalTime:nil];
    [self setRouteFP:nil];
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}

@end
