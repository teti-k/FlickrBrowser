//
//  Photo+Flickr.m
//  FlickrBrowser
//
//  Created by Zshcbka on 10/24/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Location+TakePicture.h"
#import "LocationViewController.h"
#import "Tag+Add.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
   // NSLog(@"matches count = %d", [matches count]);
    if (!matches || ([matches count] > 1)) {
        // handle error;
        NSLog(@"error");
        
    } else if ([matches count] == 0)
        {
            photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
            photo.unique = flickrInfo[FLICKR_PHOTO_ID];
            photo.title = flickrInfo[FLICKR_PHOTO_TITLE];
            photo.subtitle = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
            photo.imageURL = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];
            photo.whereTaken = [Location locationName:flickrInfo[FLICKR_PHOTO_PLACE_NAME] inManagedObjectContext:context];
            NSSet *setOfTagNames = [NSSet setWithArray:[flickrInfo[FLICKR_TAGS] componentsSeparatedByString:@" "]];
            photo.tag = [Tag tagNames:setOfTagNames inManagedObjectContext:context];
            NSLog(@"flickr photo %@", flickrInfo);
        }  else {
                photo = [matches lastObject];
                }
    return photo;
}

+ (void) deletePhotoWithFlickrInfo:(NSDictionary *)flickrInfo
            inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSLog(@"photo to delete %@", flickrInfo[FLICKR_PHOTO_ID]);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", flickrInfo[FLICKR_PHOTO_ID]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] == 0)) {
        //do nothing
        
    } else if ([matches count] == 1)
    {
        //delete
        [context deleteObject:[matches lastObject]];
        [context save:nil];
        
    }
}

@end
