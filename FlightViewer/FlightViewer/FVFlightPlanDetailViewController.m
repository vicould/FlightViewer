//
//  FlightViewerViewController.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FVFlightPlanDetailViewController.h"
#import "FVGraphViewController.h"
#import "FVMapViewController.h"


@interface FVFlightPlanDetailViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation FVFlightPlanDetailViewController

@synthesize flightInfo = _flighInfo;
@synthesize flightsDatabase = _flightDatabase;
@synthesize dateFormatter = _dateFormatter;

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"HH:mm:ss ZZZ MM/dd/yyyy";
    }
    return _dateFormatter;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    else if (section == 1) {
        return 2;
    }
    else {
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"A/C information";
    }
    else if (section == 1) {
        return @"Departure information";
    }
    else {
        return @"Arrival information";
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"flight info"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"flight info"];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Flight";
            cell.detailTextLabel.text = self.flightInfo.acFlightId;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Airline";
            cell.detailTextLabel.text = self.flightInfo.airline;
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"Type";
            cell.detailTextLabel.text = self.flightInfo.acType;
        } 
        else {
            cell.textLabel.text = @"Route";
            cell.detailTextLabel.text = self.flightInfo.flightPlan;
            cell.detailTextLabel.lineBreakMode = UILineBreakModeCharacterWrap;
            cell.detailTextLabel.numberOfLines = 0;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Airport";
            cell.detailTextLabel.text = self.flightInfo.airportDeparture;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"Time";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.flightInfo.departureTime];
        }
    }
    else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Airport";
            cell.detailTextLabel.text = self.flightInfo.airportArrival;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"Time";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.flightInfo.arrivalTime];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 3) {
        if ([self.flightInfo.flightPlan length] <= 16) {
            return tableView.rowHeight;
        } else {
            CGSize detailSize = [self.flightInfo.flightPlan sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(270, 4000) lineBreakMode:UILineBreakModeCharacterWrap];
            return detailSize.height + 12;
        }
    } else {
        return tableView.rowHeight;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = self.flightInfo.acFlightId;
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
    NSFetchRequest *pointsRequest = [NSFetchRequest fetchRequestWithEntityName:@"RoutePoint"];
    pointsRequest.predicate = [NSPredicate predicateWithFormat:@"whoFlown.fid = %lld", [self.flightInfo.fid longLongValue]];
    pointsRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES], nil];
    
    NSFetchedResultsController *flightPointsResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:pointsRequest managedObjectContext:self.flightsDatabase.managedObjectContext sectionNameKeyPath:nil cacheName:[NSString stringWithFormat:@"Route %@", self.flightInfo.acFlightId]];
    
    NSError *error = nil;
    BOOL success = [flightPointsResultsController performFetch:&error];
    if (!success) {
        NSLog(@"Fetched failed: %@", [error localizedDescription]);
    }
    
    NSArray *flightPoints = flightPointsResultsController.fetchedObjects;
    
    [segue.destinationViewController setFlightPoints:flightPoints];
    [segue.destinationViewController setFlightInfo:self.flightInfo];
}

@end
