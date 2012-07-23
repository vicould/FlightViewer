//
//  FVAirlineSelection.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FVAirlineSelection.h"
#import "Airline.h"
#import "FVFlightPlanSelectionViewController.h"
#import "FlightInfo.h"

@interface FVAirlineSelection ()

@property (nonatomic, strong) NSString *lastSearchTerm;
@property (nonatomic, strong) NSArray *searchResults;

@end

@implementation FVAirlineSelection

@synthesize flightsDatabase = _flightsDatabase;
@synthesize lastSearchTerm = _lastSearchTerm;
@synthesize searchResults = _searchResults;

- (NSArray *)searchResults {
    if (!_searchResults) {
        _searchResults = [NSArray array];
    }
    return _searchResults;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Airlines";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        // supports only portrait
        return YES;
    }
    return NO;
}

#pragma mark - Data fetching

-(void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Airline"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.flightsDatabase.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
}

-(void)useDocument
{  
    NSURL *databaseURL = self.flightsDatabase.fileURL;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:databaseURL.path]) {
        // if document does not exist
        NSURL *resourceURL = [[NSBundle mainBundle] URLForResource:@"FlightViewer" withExtension:@"sqlite"];
        NSURL *destURL = [databaseURL URLByAppendingPathComponent:@"StoreContent"];
        [[NSFileManager defaultManager] createDirectoryAtURL:destURL withIntermediateDirectories:YES attributes:nil error:NULL];
        NSURL *finalURL = [destURL URLByAppendingPathComponent:@"persistentStore"];
        
        NSError *error = nil;
        if ([[NSFileManager defaultManager] copyItemAtURL:resourceURL toURL:finalURL error:&error]) {
            NSLog(@"Started data copy to %@", self.flightsDatabase.fileURL.path);
            [self setupFetchedResultsController];
        } else {
            NSLog(@"Error while copying data: %@", error);
        }
    } else if (self.flightsDatabase.documentState == UIDocumentStateClosed) {
        // document not opened
        [self.flightsDatabase openWithCompletionHandler:^(BOOL success) { 
            [self setupFetchedResultsController];
        }];
    } else if (self.flightsDatabase.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
    }
}

- (void)setFlightsDatabase:(UIManagedDocument *)flightsDatabase
{
    if (!_flightsDatabase) {
        _flightsDatabase = flightsDatabase;
        [self useDocument];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.flightsDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"FlighViewerDB"];
        UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
        document.persistentStoreOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        self.flightsDatabase = document;
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"airline"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"airline"];
    }
    // Configure the cell...
    //    cell.imageView.image = [UIImage imageNamed:@"delta"];
    Airline *airline = nil;
    if (tableView == self.tableView) {
        airline = [self.fetchedResultsController objectAtIndexPath:indexPath];
    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
        airline = [self.searchResults objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = airline.name;
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [super numberOfSectionsInTableView:tableView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return @"";
    } else {
        return [super tableView:tableView titleForHeaderInSection:section];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [super tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [NSArray array];
    } else {
        return [super sectionIndexTitlesForTableView:tableView];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setFlightsDatabase:self.flightsDatabase];
    [segue.destinationViewController setCurrentAirline:[[sender textLabel] text]];
    
}

#pragma mark - Search

- (void)searchForTerm:(NSString *)query {
    NSFetchRequest *userSearchingFlightPlansRequest = [NSFetchRequest fetchRequestWithEntityName:@"Airline"];
    userSearchingFlightPlansRequest.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", query];
    userSearchingFlightPlansRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    
    NSFetchedResultsController *flightPlansResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:userSearchingFlightPlansRequest managedObjectContext:self.flightsDatabase.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    BOOL success = [flightPlansResultsController performFetch:&error];
    if (!success) {
        NSLog(@"Fetched failed: %@", [error localizedDescription]);
    }
    
    self.searchResults = flightPlansResultsController.fetchedObjects;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self searchForTerm:searchString];
    
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    self.lastSearchTerm = nil;
    
    [self.tableView reloadData];
}


@end
