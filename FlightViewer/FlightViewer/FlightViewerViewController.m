//
//  FlightViewerViewController.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlightViewerViewController.h"
#import "FlightViewerFPDetail.h"
#import "FlightViewerSubViewGraphController.h"
#import "FlightViewerSubViewMapController.h"

static NSUInteger kNumberOfPages = 2;

@interface FlightViewerViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *subViewControllers;
// we want to keep track of who triggered the page change: the user dragging or the user interacting with the page control
@property (nonatomic) BOOL pageControlUsed;

@property (nonatomic, strong) FlightViewerFPDetail *fpDetail;

- (void)loadScrollViewWithPage:(int)page;

- (IBAction)changePage:(id)sender;

@end

@implementation FlightViewerViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize subViewControllers = _subViewControllers;
@synthesize pageControlUsed = _pageControlUsed;

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
    self.pageControl.numberOfPages = kNumberOfPages;
    // sets the size of the scrollview, which contains kNumberOfPages
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * kNumberOfPages, self.scrollView.frame.size.height);
    self.subViewControllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < kNumberOfPages; i++) {
        [self.subViewControllers addObject:[NSNull null]];
    }
    // prepares the first two pages
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        // supports only landscape
        return YES;
    }
    return NO;
}

/*
 * This method loads the controller and the view for the specified page.
 * @param page The index of the page, starts at 0.
 */
- (void)loadScrollViewWithPage:(int)page
{
    // prevents treating the case of an index out of bounds
    if (page < 0 || page > kNumberOfPages - 1) {
        return;
    }
    // loads the view controller from the list of subview controllers
    UIViewController *currentViewController = [self.subViewControllers objectAtIndex:page];
    // if it is null, i.e. we did not create it yet, let's initialize it.
    if ((NSNull *)currentViewController == [NSNull null]) {
        // here we initialize C1 or C2
        FlightViewerSubViewMapController *mapController = nil;
        FlightViewerSubViewGraphController *graphController = nil;
        switch (page) {
            case 0:
                // page 0, the map
                mapController = [[FlightViewerSubViewMapController alloc] initWithNibName:@"FlightViewerSubViewMapController" bundle:nil];
                mapController.fpDetail = self.fpDetail;
                currentViewController = mapController;
                break;
                
            case 1:
                // page 1, the graph
                graphController = [[FlightViewerSubViewGraphController alloc] initWithNibName:@"FlightViewerSubViewGraphController" bundle:nil];
                graphController.fpDetail = self.fpDetail;
                currentViewController = graphController;
                break;
                
            default:
                currentViewController = nil;
                break;
        }  
    }
    // sets the correct bounds to the subview
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    currentViewController.view.frame = frame;
    [self.scrollView addSubview:currentViewController.view];
    
}

#pragma mark - UIScrollViewDelegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // the user was not dragging, let's return
    if (self.pageControlUsed) {
        return;
    }
    // switches the page indicator when the page is halfway through
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    // loads the current page, and the two neighbors
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page+1];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // resets the boolean, the user is dragging
    self.pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
}

# pragma mark - Action triggered by the page control

/*
 * Method to change the page when the user is interacting directly with the page control.
 * @param sender It is an IBAction, so we have a sender. It should be a UIPageControl in that case.
 */
- (IBAction)changePage:(id)sender
{
    // prepares the pages around the new page (it already changed to the new one, but did not show it yet)
    int page = self.pageControl.currentPage;
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page+1];
    
    self.pageControlUsed = YES;
    
    // scrolls the view to show the new page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}


@end
