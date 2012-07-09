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
	// Do any additional setup after loading the view.
    // Passes useful information for subview V2
    self.graphView.altitude = [self.fpDetail.altitude copy];
    self.graphView.speed = [self.fpDetail.speed copy];
    self.graphView.time = [self.fpDetail.time copy];
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
