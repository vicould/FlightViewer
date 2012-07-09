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

@end

@implementation FlightViewerSubViewGraphController

@synthesize fpDetail = _fpDetail;

- (id)initWithFPDetail:(FlightViewerFPDetail *)fpDetail
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.fpDetail = fpDetail;
        // Create subview V2
        FlightViewerSubViewGraph *subView = [[FlightViewerSubViewGraph alloc] init];
        subView.altitude = [self.fpDetail.altitude copy];
        subView.speed = [self.fpDetail.speed copy];
        subView.time = [self.fpDetail.time copy];
        self.view = subView;
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
    return YES;
}

@end
