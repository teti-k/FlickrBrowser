//
//  Tag+Add.m
//  FlickrBrowser
//
//  Created by Zshcbka on 11/7/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "Tag+Add.h"

@implementation Tag (Add)
+ (NSSet *) tagNames:(NSSet *)setOfTagNames inManagedObjectContext:(NSManagedObjectContext *)context
{
    Tag *tag;
    NSMutableSet *tagSet = [NSMutableSet set];
    for (NSString *name in setOfTagNames)
    {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
//    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

    NSError *error = nil;
    NSArray *tags = [context executeFetchRequest:request error:&error];
    
    if (!tags || ([tags count] > 1)) {
        // handle error
    } else if ([tags count] == 0)
    {
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                                 inManagedObjectContext:context];
        tag.name = name;
    } else {
        tag = [tags lastObject];
    }
        [tagSet addObject:tag];
        
    }

    return tagSet;
}
@end
