//
//  FlightViewerSubViewGraph.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlightViewerSubViewGraph.h"

@interface FlightViewerSubViewGraph ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end


@implementation FlightViewerSubViewGraph

@synthesize dateFormatter = _dateFormatter;

@synthesize altitude = _altitude;
@synthesize speed = _speed;
@synthesize time = _time;

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"HH:mm";
    }
    return _dateFormatter;
}

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
    originBotLeftLabel.font = [UIFont systemFontOfSize:12];
    originBotLeftLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:originBotLeftLabel];
    
    // y axis label Top left
    UILabel *originTopLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, 50, 12)];
    originTopLeftLabel.text = @"V";
    originTopLeftLabel.font = [UIFont systemFontOfSize:12];
    originTopLeftLabel.textColor = [UIColor purpleColor];
    originTopLeftLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:originTopLeftLabel];
    
    // y axis label bottom right
    UILabel *originBotRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(454, 278, 10, 12)];
    originBotRightLabel.text = @"0";
    originBotRightLabel.font = [UIFont systemFontOfSize:12];
    originBotRightLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:originBotRightLabel];
    
    // y axis label Top right
    UILabel *originTopRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(458, 5, 50, 12)];
    originTopRightLabel.text = @"FL";
    originTopRightLabel.font = [UIFont systemFontOfSize:12];
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
        double ratioAltitude = - 270.0 / 40000.0;
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
    
    // scale of the y axis -> v 0 to 600 LEFT
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2.0);
    [[UIColor purpleColor] setStroke];
    
    // y axis label Top left
    UILabel *LeftLabel100 = [[UILabel alloc] initWithFrame:CGRectMake(5, 242, 50, 8)];
    LeftLabel100.text = @"100";
    LeftLabel100.font = [UIFont systemFontOfSize:12];
    LeftLabel100.textColor = [UIColor purpleColor];
    LeftLabel100.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:LeftLabel100];
    CGContextMoveToPoint(context, 26, 245);
    CGContextAddLineToPoint(context, 34, 245);
   
    UILabel *LeftLabel200 = [[UILabel alloc] initWithFrame:CGRectMake(5, 197, 50, 8)];
    LeftLabel200.text = @"200";
    LeftLabel200.font = [UIFont systemFontOfSize:12];
    LeftLabel200.textColor = [UIColor purpleColor];
    LeftLabel200.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:LeftLabel200];
    CGContextMoveToPoint(context, 26, 200);
    CGContextAddLineToPoint(context, 34, 200);
    
    UILabel *LeftLabel300 = [[UILabel alloc] initWithFrame:CGRectMake(5, 152, 50, 8)];
    LeftLabel300.text = @"300";
    LeftLabel300.font = [UIFont systemFontOfSize:12];
    LeftLabel300.textColor = [UIColor purpleColor];
    LeftLabel300.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:LeftLabel300];
    CGContextMoveToPoint(context, 26, 155);
    CGContextAddLineToPoint(context, 34, 155);
    
    UILabel *LeftLabel400 = [[UILabel alloc] initWithFrame:CGRectMake(5, 107, 50, 8)];
    LeftLabel400.text = @"400";
    LeftLabel400.font = [UIFont systemFontOfSize:12];
    LeftLabel400.textColor = [UIColor purpleColor];
    LeftLabel400.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:LeftLabel400];
    CGContextMoveToPoint(context, 26, 110);
    CGContextAddLineToPoint(context, 34, 110);

    UILabel *LeftLabel500 = [[UILabel alloc] initWithFrame:CGRectMake(5, 62, 50, 8)];
    LeftLabel500.text = @"500";
    LeftLabel500.font = [UIFont systemFontOfSize:12];
    LeftLabel500.textColor = [UIColor purpleColor];
    LeftLabel500.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:LeftLabel500];
    CGContextMoveToPoint(context, 26, 65);
    CGContextAddLineToPoint(context, 34, 65);
    
    CGContextStrokePath(context);
    
    // scale of the y axis -> h 0 to 390 RIGHT
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blueColor] setStroke];
    
    // y axis label Top left
    UILabel *RightLabel100 = [[UILabel alloc] initWithFrame:CGRectMake(455, 219.5, 50, 8)];
    RightLabel100.text = @"100";
    RightLabel100.font = [UIFont systemFontOfSize:12];
    RightLabel100.textColor = [UIColor blueColor];
    RightLabel100.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:RightLabel100];
    CGContextMoveToPoint(context, 446, 222.5);
    CGContextAddLineToPoint(context, 454, 222.5);
    
    UILabel *RightLabel200 = [[UILabel alloc] initWithFrame:CGRectMake(455, 152, 50, 8)];
    RightLabel200.text = @"200";
    RightLabel200.font = [UIFont systemFontOfSize:12];
    RightLabel200.textColor = [UIColor blueColor];
    RightLabel200.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:RightLabel200];
    CGContextMoveToPoint(context, 446, 155);
    CGContextAddLineToPoint(context, 454, 155);
    
    UILabel *RightLabel300 = [[UILabel alloc] initWithFrame:CGRectMake(455, 84.5, 50, 8)];
    RightLabel300.text = @"300";
    RightLabel300.font = [UIFont systemFontOfSize:12];
    RightLabel300.textColor = [UIColor blueColor];
    RightLabel300.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:RightLabel300];
    CGContextMoveToPoint(context, 446, 87.5);
    CGContextAddLineToPoint(context, 454, 87.5);
    
    UILabel *RightLabel390 = [[UILabel alloc] initWithFrame:CGRectMake(455, 23.75, 50, 8)];
    RightLabel390.text = @"390";
    RightLabel390.font = [UIFont systemFontOfSize:12];
    RightLabel390.textColor = [UIColor blueColor];
    RightLabel390.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:RightLabel390];
    CGContextMoveToPoint(context, 446, 26.75);
    CGContextAddLineToPoint(context, 454, 26.75);
 
    CGContextStrokePath(context);

    // scale on the x axis
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blackColor] setStroke];
    
    NSDate *departureTime = [self.time objectAtIndex:0];
    NSDate *arrivalTime = [self.time objectAtIndex:self.time.count - 1];
    
    UILabel *xLabelDeparture = [[UILabel alloc] initWithFrame:CGRectMake(30, 290, 30, 30)];
    xLabelDeparture.text = [self.dateFormatter stringFromDate:departureTime];
    xLabelDeparture.font = [UIFont systemFontOfSize:9];
    xLabelDeparture.textColor = [UIColor blackColor];
    xLabelDeparture.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [xLabelDeparture setTransform: CGAffineTransformMakeRotation(M_PI / 4)];
    [self addSubview:xLabelDeparture];
    CGContextMoveToPoint(context, 30, 285);
    CGContextAddLineToPoint(context, 30, 295);
    
    UILabel *xLabelArrival = [[UILabel alloc] initWithFrame:CGRectMake(450, 290, 30, 30)];
    xLabelArrival.text = [self.dateFormatter stringFromDate:arrivalTime];
    xLabelArrival.font = [UIFont systemFontOfSize:9];
    xLabelArrival.textColor = [UIColor blackColor];
    xLabelArrival.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [xLabelArrival setTransform: CGAffineTransformMakeRotation(M_PI / 4)];
    [self addSubview:xLabelArrival];
    CGContextMoveToPoint(context, 450, 285);
    CGContextAddLineToPoint(context, 450, 295);
    
    double xPosition = 0;
    
    NSTimeInterval flightDuration = [arrivalTime timeIntervalSinceDate:departureTime];
    NSTimeInterval flightTimeInterval = flightDuration/5;
    for (int i = 1; i < 5; i++) {
        xPosition = 35 + i * 83;
        UILabel *xLabelTime = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 290, 30, 30)];
        NSDate *inFLightTime = [departureTime dateByAddingTimeInterval:(flightTimeInterval * i)];
        xLabelTime.text = [self.dateFormatter stringFromDate:inFLightTime];
        xLabelTime.font = [UIFont systemFontOfSize:9];
        xLabelTime.textColor = [UIColor blackColor];
        xLabelTime.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        [xLabelTime setTransform: CGAffineTransformMakeRotation(M_PI / 4)];
        [self addSubview:xLabelTime];
        CGContextMoveToPoint(context, xPosition, 285);
        CGContextAddLineToPoint(context, xPosition, 295);
    }

    CGContextStrokePath(context);
   
}

@end
