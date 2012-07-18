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
    
    // axis
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2.0);
    
    UIColor *color = [UIColor blackColor];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    // x axis
    CGContextMoveToPoint(context, 30, 290);
    CGContextAddLineToPoint(context, 450, 290);
    
    // x axis right arrow
    CGContextMoveToPoint(context, 450, 290);
    CGContextAddLineToPoint(context, 445, 285);
    CGContextMoveToPoint(context, 450, 290);
    CGContextAddLineToPoint(context, 445, 295);
    
    // y axis left
    CGContextMoveToPoint(context, 30, 290);
    CGContextAddLineToPoint(context, 30, 20);
    
    // y axis left arrow
    CGContextMoveToPoint(context, 30, 20);
    CGContextAddLineToPoint(context, 35, 25);
    CGContextMoveToPoint(context, 30, 20);
    CGContextAddLineToPoint(context, 25, 25);
    
    // y axis right
    CGContextMoveToPoint(context, 450, 290);
    CGContextAddLineToPoint(context, 450, 20);
    
    // y axis right arrow
    CGContextMoveToPoint(context, 450, 20);
    CGContextAddLineToPoint(context, 455, 25);
    CGContextMoveToPoint(context, 450, 20);
    CGContextAddLineToPoint(context, 445, 25);
    
    CGContextStrokePath(context);
    
    // y axis label bottom left
    UILabel *originBotLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 278, 10, 12)];
    originBotLeftLabel.text = @"0";
    originBotLeftLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:originBotLeftLabel];
    
    // y axis label Top left
    UILabel *originTopLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 50, 22)];
    originTopLeftLabel.text = @"V";
    originTopLeftLabel.textColor = [UIColor purpleColor];
    originTopLeftLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:originTopLeftLabel];
    
    // y axis label bottom right
    UILabel *originBotRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(454, 278, 10, 12)];
    originBotRightLabel.text = @"0";
    originBotRightLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:originBotRightLabel];
    
    // y axis label Top right
    UILabel *originTopRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(458, 15, 50, 22)];
    originTopRightLabel.text = @"FL";
    originTopRightLabel.textColor = [UIColor blueColor];
    originTopRightLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:originTopRightLabel];
    
    
    // only draws if information is available in the view
    if ([self.time count] > 0) {
        // add code for graph
        
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 1.5);
        [[UIColor blueColor] setStroke];
        
        // init h movetopoint
        CGPoint hStart;
        int t0 = [[self.time objectAtIndex:0] timeIntervalSince1970];
        double ratioTime = 420.0 / ([[self.time objectAtIndex:([self.time count] - 1)] timeIntervalSince1970] - t0);
        double ratioAltitude = - 270.0 / 39000.0;
        hStart.x = 30.0;
        hStart.y = ([[self.altitude objectAtIndex:0] doubleValue]) * ratioAltitude + 290.0;
        
        CGContextMoveToPoint(context, hStart.x, hStart.y);
        
        // for h addlinetopoint
        for (int i = 1; i < [self.altitude count]; i++) {
            CGContextAddLineToPoint(context, ([[self.time objectAtIndex:i] timeIntervalSince1970] - t0) * ratioTime + 30.0, ([[self.altitude objectAtIndex:i] doubleValue]) *ratioAltitude + 290.0);
        }
        
        CGContextStrokePath(context);
        
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 1.5);
        [[UIColor purpleColor] setStroke];
        // init v
        CGPoint vStart;
        double ratioSpeed = - 270.0 / 600.0;
        vStart.x = 30.0;
        vStart.y = ([[self.speed objectAtIndex:0] doubleValue]) *ratioSpeed + 290.0;
        
        CGContextMoveToPoint(context, vStart.x, vStart.y);
        
        // for v
        for (int i = 1; i < [self.speed count]; i++) {
            CGContextAddLineToPoint(context, ([[self.time objectAtIndex:i] timeIntervalSince1970] - t0) * ratioTime + 30.0, ([[self.speed objectAtIndex:i] doubleValue]) * ratioSpeed + 290.0);
        }
        
        CGContextStrokePath(context);

    }
}

@end
