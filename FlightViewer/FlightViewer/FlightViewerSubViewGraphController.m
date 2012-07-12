//
//  FlightViewerSubViewGraphController.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlightViewerSubViewGraphController.h"
#import "FlightViewerSubViewGraph.h"

@interface FlightViewerSubViewGraphController ()

// an outlet to keep track of the main view of this controller, which is the graph.
@property (nonatomic, strong) IBOutlet FlightViewerSubViewGraph *graphView;

@end

@implementation FlightViewerSubViewGraphController

@synthesize fpDetail = _fpDetail;
@synthesize graphView = _subView;

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
    self.graphView.altitude = [self.fpDetail.altitude copy];
    self.graphView.speed = [self.fpDetail.speed copy];
    self.graphView.time = [self.fpDetail.time copy];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        [UIView beginAnimations:@"graph" context:nil];
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
        [UIView beginAnimations:@"graph" context:nil];
        [self.navigationController.view setTransform: CGAffineTransformMakeRotation(0)];
        [self.navigationController.view setFrame:CGRectMake(0, 0, 320, 480)];
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 44)];
        [UIView commitAnimations];
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
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}



@end
