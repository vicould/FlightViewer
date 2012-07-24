//
//  FlightViewerSubViewGraphController.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FVGraphViewController.h"
#import "FVSubViewGraph.h"
#import "RoutePoint.h"

@interface FVGraphViewController ()

// an outlet to keep track of the main view of this controller, which is the graph.
@property (nonatomic, strong) IBOutlet FVSubViewGraph *graphView;
- (IBAction)toggleNavigationBar:(id)sender;

@end

@implementation FVGraphViewController

@synthesize flightPoints = _flightPoints;
@synthesize flightInfo = _flightInfo;
@synthesize graphView = _graphView;

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
	// Do any additional setup after loading the view.
    
    // Passes useful information for subview V2
    NSMutableArray *altitude = [NSMutableArray array];
    NSMutableArray *speed = [NSMutableArray array];
    NSMutableArray *time = [NSMutableArray array];
    
    for (RoutePoint *routePoint in self.flightPoints) {
        [altitude addObject:routePoint.altitude];
        [speed addObject:routePoint.speed];
        [time addObject:routePoint.time];
    }
    
    self.graphView.altitude = altitude;
    self.graphView.speed = speed;
    self.graphView.time = time;
    
    [self.graphView setNeedsDisplay];
    self.title = @"V and FL time history profiles";
}

- (void)viewWillAppear:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        [UIView beginAnimations:@"graph" context:nil];
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
        [UIView beginAnimations:@"graph" context:nil];
        [self.navigationController.view setTransform: CGAffineTransformMakeRotation(0)];
        [self.navigationController.view setFrame:CGRectMake(0, 0, 320, 480)];
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 44)];
        [UIView commitAnimations];
    }
    [UIView setAnimationsEnabled:YES];
    [super viewWillDisappear:animated];
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
