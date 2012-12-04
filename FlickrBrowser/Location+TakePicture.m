//
//  Location+TakePicture.m
//  FlickrBrowser
//
//  Created by Zshcbka on 10/24/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "Location+TakePicture.h"
#import "FlickrFetcher.h"

@implementation Location (TakePicture)

+ (Location *)locationName:(NSString *)name
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    Location *location = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];

    NSError *error = nil;
    NSArray *locations = [context executeFetchRequest:request error:&error];
    
    if (!locations || ([locations count] > 1)) {
        // handle error
    } else if ([locations count] == 0)
    {
        location = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                     inManagedObjectContext:context];
        location.name = name;
    } else {
        location = [locations lastObject];
    }

    return location;
}

+ (void) deleteInContext: (NSManagedObjectContext *)context
{
    Location *location = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    //request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error = nil;
    NSArray *locations = [context executeFetchRequest:request error:&error];
    for (location in locations)
    {
        if (location.photos.count == 0)
        {
            [context deleteObject:location];
            [context save:nil];
        }
    }
}


@end
