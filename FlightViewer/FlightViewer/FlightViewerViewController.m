//
//  FlightViewerViewController.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlightViewerViewController.h"
#import "FlightViewerSubViewGraphController.h"
#import "FlightViewerSubViewMapController.h"


@interface FlightViewerViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation FlightViewerViewController

@synthesize flighInfo = _flighInfo;
@synthesize flightDatabase = _flightDatabase;
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
        return 3;
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
            cell.detailTextLabel.text = self.flighInfo.acFlightId;
        } 
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"Type";
            cell.detailTextLabel.text = self.flighInfo.acType;
        } 
        else {
            cell.textLabel.text = @"Route";
            cell.detailTextLabel.text = self.flighInfo.flightPlan;
            cell.detailTextLabel.lineBreakMode = UILineBreakModeCharacterWrap;
            cell.detailTextLabel.numberOfLines = 0;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Airport";
            cell.detailTextLabel.text = self.flighInfo.airportDeparture;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"Time";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.flighInfo.departureTime];
        }
    }
    else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Airport";
            cell.detailTextLabel.text = self.flighInfo.airportArrival;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"Time";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.flighInfo.arrivalTime];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2) {
        if ([self.flighInfo.flightPlan length] <= 16) {
            return tableView.rowHeight;
        } else {
            CGSize detailSize = [self.flighInfo.flightPlan sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(270, 4000) lineBreakMode:UILineBreakModeCharacterWrap];
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
    self.title = self.flighInfo.acFlightId;
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
    pointsRequest.predicate = [NSPredicate predicateWithFormat:@"whoFlown.acFlightId = %@", self.flighInfo.acFlightId];
    pointsRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES], nil];
    
    NSFetchedResultsController *flightPointsResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:pointsRequest managedObjectContext:self.flightDatabase.managedObjectContext sectionNameKeyPath:nil cacheName:[NSString stringWithFormat:@"Route %@", self.flighInfo.acFlightId]];
    
    NSError *error = nil;
    BOOL success = [flightPointsResultsController performFetch:&error];
    if (!success) {
        NSLog(@"Fetched failed: %@", [error localizedDescription]);
    }
    
    NSArray *flightPoints = flightPointsResultsController.fetchedObjects;
    
    [segue.destinationViewController setFlightPoints:flightPoints];
    [segue.destinationViewController setFlighInfo:self.flighInfo];
}

@end
