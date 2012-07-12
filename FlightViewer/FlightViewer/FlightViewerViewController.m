//
//  FlightViewerViewController.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlightViewerViewController.h"
#import "FlightViewerFPDetail.h"


@interface FlightViewerViewController ()

@property (nonatomic, strong) FlightViewerFPDetail *fpDetail;

@end

@implementation FlightViewerViewController

@synthesize fpDetail = _fpDetail;

- (FlightViewerFPDetail *)fpDetail
{
    if (!_fpDetail) {
        _fpDetail = [[FlightViewerFPDetail alloc] init];
    }
    return _fpDetail;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = self.fpDetail.acFlightId;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        // supports only portrait
        return YES;
    }
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    [segue.destinationViewController setFpDetail:self.fpDetail];
}

@end
