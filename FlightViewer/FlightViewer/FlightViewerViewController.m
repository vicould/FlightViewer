//
//  FlightViewerViewController.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlightViewerViewController.h"

static NSUInteger kNumberOfPages = 2;

@interface FlightViewerViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *subViewControllers;
@property (nonatomic) BOOL pageControlUsed;

- (void)loadScrollViewWithPage:(int)page;

- (IBAction)changePage:(id)sender;

@end

@implementation FlightViewerViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize subViewControllers = _subViewControllers;
@synthesize pageControlUsed = _pageControlUsed;

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

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0 || page > kNumberOfPages) {
        return;
    }
    UIViewController *currentViewController = [self.subViewControllers objectAtIndex:page];
    if ((NSNull *)currentViewController == [NSNull null]) {
        // here we initialize C1 or C2
    }
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    currentViewController.view.frame = frame;
    [self.scrollView addSubview:currentViewController.view];
    
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
