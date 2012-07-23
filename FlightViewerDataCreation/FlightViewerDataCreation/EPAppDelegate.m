//
//  EPAppDelegate.m
//  FlightViewerDataCreation
//
//  Created by Ludovic Delaveau on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EPAppDelegate.h"
#import "RoutePoint.h"
#import "FlightInfo.h"

@implementation EPAppDelegate

@synthesize window = _window;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize managedObjectContext = __managedObjectContext;

- (void)dealloc
{
    [__persistentStoreCoordinator release];
    [__managedObjectModel release];
    [__managedObjectContext release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self performSelectorInBackground:@selector(loadInitialData) withObject:nil];
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "edu.purdue.FlightViewerDataCreation" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"edu.purdue.FlightViewerDataCreation"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel) {
        return __managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FlightPlanModel" withExtension:@"mom"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator) {
        return __persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![[properties objectForKey:NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"FlightViewer.sqlite"];
    NSPersistentStoreCoordinator *coordinator = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom] autorelease];
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    __persistentStoreCoordinator = [coordinator retain];
    
    return __persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];

    return __managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!__managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[[NSAlert alloc] init] autorelease];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

#pragma mark - Data loading

- (void)loadInitialData {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSDictionary *flightInfos = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"arrival_ATL_flight_info" ofType:@"plist"]];
    
    NSDictionary *routePoints = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"arrival_ATL_route_points" ofType:@"plist"]];
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    NSMutableDictionary *flightInfoSaved = [[NSMutableDictionary alloc] init];
    
    for (NSString *flightId in routePoints) {
        NSArray *routePointsList = [routePoints objectForKey:flightId];
        
        for (NSDictionary *routePointData in routePointsList) {
            RoutePoint *routePoint = [NSEntityDescription insertNewObjectForEntityForName:@"RoutePoint" inManagedObjectContext:context];
            routePoint.fid = [NSNumber numberWithLongLong:[flightId longLongValue]];
            routePoint.altitude = [routePointData objectForKey:@"altitude"];
            routePoint.latitude = [routePointData objectForKey:@"latitude"];
            routePoint.longitude = [routePointData objectForKey:@"longitude"];
            routePoint.speed = [routePointData objectForKey:@"speed"];
            routePoint.time = [routePointData objectForKey:@"time"];

            
            FlightInfo *flightInfo = [flightInfoSaved objectForKey:flightId];
            if (!flightInfo) {
                flightInfo = [NSEntityDescription insertNewObjectForEntityForName:@"FlightInfo" inManagedObjectContext:context];
                NSDictionary *flightInfoItems = [flightInfos objectForKey:flightId];
                flightInfo.fid = routePoint.fid;
                flightInfo.acFlightId = [flightInfoItems objectForKey:@"acId"];
                flightInfo.acType = [flightInfoItems objectForKey:@"acType"];
                flightInfo.airportDeparture = [flightInfoItems objectForKey:@"airportDeparture"];
                flightInfo.departureTime = [flightInfoItems objectForKey:@"departureTime"];
                flightInfo.airportArrival = [flightInfoItems objectForKey:@"airportArrival"];
                flightInfo.arrivalTime = [flightInfoItems objectForKey:@"arrivalTime"];
                flightInfo.flightPlan = [flightInfoItems objectForKey:@"flightPlan"];
                flightInfo.airline = [self detectAirline:flightInfo.acFlightId];
                
                [flightInfoSaved setObject:flightInfo forKey:flightId];
            }
            
            routePoint.whoFlown = flightInfo;
        }
    }
    NSLog(@"Finished loading the flight points");
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Error saving: %@", error);
    }
    
    [pool drain];
}

- (NSString *)detectAirline:(NSString *)acFlightId
{
    NSString *airlineCode = [acFlightId substringToIndex:3];
    if ([airlineCode isEqualToString:@"AAL"]) {
        return @"American Airlines";
    } else if ([airlineCode isEqualToString:@"AAR"]) {
        return @"Asiana Airlines";
    } else if ([airlineCode isEqualToString:@"AAY"]) {
        return @"Allegiant Air";
    } else if ([airlineCode isEqualToString:@"ABX"]) {
        return @"Airborne Express";
    } else if ([airlineCode isEqualToString:@"AFR"]) {
        return @"Air France";
    } else if ([airlineCode isEqualToString:@"AJI"]) {
        return @"Ameristar Jet Charter";
    } else if ([airlineCode isEqualToString:@"ASA"]) {
        return @"Alaska Airlines";
    } else if ([airlineCode isEqualToString:@"ASH"]) {
        return @"Mesa Airlines";
    } else if ([airlineCode isEqualToString:@"ASO"]) {
        return @"Aero Slovakia";
    } else if ([airlineCode isEqualToString:@"ASQ"]) {
        return @"Atlantic Southeast Airlines";
    } else if ([airlineCode isEqualToString:@"ATN"]) {
        return @"Air Transport International";
    } else if ([airlineCode isEqualToString:@"AWE"]) {
        return @"America West Airlines";
    } else if ([airlineCode isEqualToString:@"AWI"]) {
        return @"Air Wisconsin";
    } else if ([airlineCode isEqualToString:@"BAW"]) {
        return @"British Airways";
    } else if ([airlineCode isEqualToString:@"BJS"]) {
        return @"Business Jet Solutions";
    } else if ([airlineCode isEqualToString:@"BOX"]) {
        return @"Tiphook PLC";
    } else if ([airlineCode isEqualToString:@"BTA"]) {
        return @"ExpressJet";
    } else if ([airlineCode isEqualToString:@"CAL"]) {
        return @"China Airlines";
    } else if ([airlineCode isEqualToString:@"CGP"]) {
        return @"Cargo Plus Aviation";
    } else if ([airlineCode isEqualToString:@"CHQ"]) {
        return @"Chautauqua Airlines";
    } else if ([airlineCode isEqualToString:@"CKK"]) {
        return @"China Cargo Airlines";
    } else if ([airlineCode isEqualToString:@"CKS"]) {
        return @"Kalitta Air";
    } else if ([airlineCode isEqualToString:@"CLX"]) {
        return @"Cargolux";
    } else if ([airlineCode isEqualToString:@"COA"]) {
        return @"Continental Airlines";
    } else if ([airlineCode isEqualToString:@"COM"]) {
        return @"Comair";
    } else if ([airlineCode isEqualToString:@"CPA"]) {
        return @"Cathay Pacifc";
    } else if ([airlineCode isEqualToString:@"CPZ"]) {
        return @"Compass Airlines";
    } else if ([airlineCode isEqualToString:@"DAL"]) {
        return @"Delta Airlines";
    } else if ([airlineCode isEqualToString:@"DCM"]) {
        return @"FLTPLAN";
    } else if ([airlineCode isEqualToString:@"DHL"]) {
        return @"Astar Air Cargo";
    } else if ([airlineCode isEqualToString:@"DOJ"]) {
        return @"Justice Prisoner and Alien Transportation System";
    } else if ([airlineCode isEqualToString:@"EGF"]) {
        return @"American Eagle";
    } else if ([airlineCode isEqualToString:@"EJA"]) {
        return @"NetJets";
    } else if ([airlineCode isEqualToString:@"EJM"]) {
        return @"Executive Jet Management";
    } else if ([airlineCode isEqualToString:@"ELJ"]) {
        return @"Delta Air Elite";
    } else if ([airlineCode isEqualToString:@"EVA"]) {
        return @"EVA Air";
    } else if ([airlineCode isEqualToString:@"FDX"]) {
        return @"Federal Express";
    } else if ([airlineCode isEqualToString:@"FFT"]) {
        return @"Frontier Airlines";
    } else if ([airlineCode isEqualToString:@"FLG"]) {
        return @"Pinnacle Airlines";
    } else if ([airlineCode isEqualToString:@"FRG"]) {
        return @"Freight Runners Express";
    } else if ([airlineCode isEqualToString:@"GEC"]) {
        return @"Lufthansa Cargo";
    } else if ([airlineCode isEqualToString:@"GTI"]) {
        return @"Atlas Air";
    } else if ([airlineCode isEqualToString:@"JBU"]) {
        return @"JetBlue Airways";
    } else if ([airlineCode isEqualToString:@"JZA"]) {
        return @"Air Canada Jazz";
    } else if ([airlineCode isEqualToString:@"KAL"]) {
        return @"Korean Air";
    } else if ([airlineCode isEqualToString:@"KAT"]) {
        return @"Kato Airline";
    } else if ([airlineCode isEqualToString:@"KLM"]) {
        return @"KLM";
    } else if ([airlineCode isEqualToString:@"LAK"]) {
        return @"Lennox Airways";
    } else if ([airlineCode isEqualToString:@"LAN"]) {
        return @"LAN Airlines";
    } else if ([airlineCode isEqualToString:@"LMO"]) {
        return @"Sky Limo Corporation";
    } else if ([airlineCode isEqualToString:@"MJR"]) {
        return @"Midamerica Jet";
    } else if ([airlineCode isEqualToString:@"MTN"]) {
        return @"Mountain Air Cargo";
    } else if ([airlineCode isEqualToString:@"NAO"]) {
        return @"North American Airlines";
    } else if ([airlineCode isEqualToString:@"NKS"]) {
        return @"Spirit Airlines";
    } else if ([airlineCode isEqualToString:@"NMI"]) {
        return @"Pacific Wings";
    } else if ([airlineCode isEqualToString:@"OAE"]) {
        return @"Omni Air International";
    } else if ([airlineCode isEqualToString:@"OPT"]) {
        return @"Flight Options";
    } else if ([airlineCode isEqualToString:@"PRY"]) {
        return @"Priority Air Charter";
    } else if ([airlineCode isEqualToString:@"RBY"]) {
        return @"Vision Airlines";
    } else if ([airlineCode isEqualToString:@"RPA"]) {
        return @"Republic Airlines";
    } else if ([airlineCode isEqualToString:@"RYN"]) {
        return @"Ryan International Airlines";
    } else if ([airlineCode isEqualToString:@"SFH"]) {
        return @"Starfish";
    } else if ([airlineCode isEqualToString:@"SKW"]) {
        return @"SkyWest Airlines";
    } else if ([airlineCode isEqualToString:@"SQC"]) {
        return @"Singapore Airlines Cargo";
    } else if ([airlineCode isEqualToString:@"SUB"]) {
        return @"Suburban Air Freight";
    } else if ([airlineCode isEqualToString:@"TAM"]) {
        return @"TAM Brazilian Airlines";
    } else if ([airlineCode isEqualToString:@"TCF"]) {
        return @"Shuttle America";
    } else if ([airlineCode isEqualToString:@"TRS"]) {
        return @"AirTran Airways";
    } else if ([airlineCode isEqualToString:@"UAL"]) {
        return @"United Airlines";
    } else if ([airlineCode isEqualToString:@"UPS"]) {
        return @"United Parcel Service";
    } else if ([airlineCode isEqualToString:@"WOA"]) {
        return @"World Airways";
    } else if ([airlineCode isEqualToString:@"XAC"]) {
        return @"Air Charter World";
    } else if ([airlineCode isEqualToString:@"XSR"]) {
        return @"Executive AirShare";
    } else {
        return @"Other";
    }
}

@end
