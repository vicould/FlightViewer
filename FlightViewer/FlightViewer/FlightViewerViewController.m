//
//  FlightViewerViewController.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlightViewerViewController.h"
#import "FlightViewerFPDetail.h"

static NSUInteger kNumberOfPages = 2;

@interface FlightViewerViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *subViewControllers;
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
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * kNumberOfPages, self.scrollView.frame.size.height);
    self.subViewControllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < kNumberOfPages; i++) {
        [self.subViewControllers addObject:[NSNull null]];
    }
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0 || page > kNumberOfPages - 1) {
        return;
    }
    UIViewController *currentViewController = [self.subViewControllers objectAtIndex:page];
    if ((NSNull *)currentViewController == [NSNull null]) {
        // here we initialize C1 or C2
        currentViewController = nil;
    }
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    currentViewController.view.frame = frame;
    [self.scrollView addSubview:currentViewController.view];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.pageControlUsed) {
        return;
    }
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page+1];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    int page = self.pageControl.currentPage;
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page+1];
    
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    self.pageControlUsed = YES;
}


@end
