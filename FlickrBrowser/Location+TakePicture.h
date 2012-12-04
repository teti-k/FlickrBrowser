//
//  Location+TakePicture.h
//  FlickrBrowser
//
//  Created by Zshcbka on 10/24/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "Location.h"

@interface Location (TakePicture)

+ (Location *)locationName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void) deleteInContext: (NSManagedObjectContext *)context;

@end
