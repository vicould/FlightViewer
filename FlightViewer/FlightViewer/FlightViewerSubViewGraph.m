//
//  FlightViewerSubViewGraph.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlightViewerSubViewGraph.h"

@implementation FlightViewerSubViewGraph

@synthesize altitude = _altitude;
@synthesize speed = _speed;
@synthesize time = _time;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    
    UIColor *color = [UIColor blackColor];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    CGContextMoveToPoint(context, 30, 290);
    CGContextAddLineToPoint(context, 460, 290);
    
    CGContextMoveToPoint(context, 30, 290);
    CGContextAddLineToPoint(context, 30, 20);
    
    CGContextStrokePath(context);
    
    UILabel *originLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, 10, 12)];
    originLabel.text = @"0";
    originLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:originLabel];
}

@end
