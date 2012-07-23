//
//  FlightViewerTopViewController.m
//  FlightViewer
//
//  Created by Christabelle Bosson on 07/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FVFlightPlanSelectionViewController.h"
#import "FVFlightPlanDetailViewController.h"
#import "FlightInfo.h"

@interface FVFlightPlanSelectionViewController ()

@end

@implementation FVFlightPlanSelectionViewController

@synthesize flightPlanDatabase = _flightPlanDatabase;

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
    self.title = @"Flight plans";

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
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FlightInfo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"acFlightId" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.flightPlanDatabase.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
}

-(void)useDocument
{  
    NSURL *databaseURL = self.flightPlanDatabase.fileURL;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:databaseURL.path]) {
        // if document does not exist
        NSURL *resourceURL = [[NSBundle mainBundle] URLForResource:@"FlightViewer" withExtension:@"sqlite"];
        NSURL *destURL = [databaseURL URLByAppendingPathComponent:@"StoreContent"];
        [[NSFileManager defaultManager] createDirectoryAtURL:destURL withIntermediateDirectories:YES attributes:nil error:NULL];
        NSURL *finalURL = [destURL URLByAppendingPathComponent:@"persistentStore"];
        
        NSError *error = nil;
        if ([[NSFileManager defaultManager] copyItemAtURL:resourceURL toURL:finalURL error:&error]) {
            NSLog(@"Started data copy to %@", self.flightPlanDatabase.fileURL.path);
            [self setupFetchedResultsController];
        } else {
            NSLog(@"Error while copying data: %@", error);
        }
    } else if (self.flightPlanDatabase.documentState == UIDocumentStateClosed) {
        // document not opened
        [self.flightPlanDatabase openWithCompletionHandler:^(BOOL success) { 
            [self setupFetchedResultsController];
        }];
    } else if (self.flightPlanDatabase.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
    }
}

- (void)setFlightPlanDatabase:(UIManagedDocument *)flightPlanDatabase {
    if (!_flightPlanDatabase) {
        _flightPlanDatabase = flightPlanDatabase;
        [self useDocument];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.flightPlanDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"FlighViewerDB"];
        UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
        document.persistentStoreOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        self.flightPlanDatabase = document;
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"flight id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"flight id"];
    }
    // Configure the cell...
//    cell.imageView.image = [UIImage imageNamed:@"delta"];
    FlightInfo *flightInfo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = flightInfo.acFlightId;
    
    return cell;
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
     NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [segue.destinationViewController setFlightInfo:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    [segue.destinationViewController setFlightDatabase:self.flightPlanDatabase];
    
}

@end
