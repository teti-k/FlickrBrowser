//
//  Photo+Flickr.h
//  FlickrBrowser
//
//  Created by Zshcbka on 10/24/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo
        inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void) deletePhotoWithFlickrInfo:(NSDictionary *)flickrInfo
            inManagedObjectContext:(NSManagedObjectContext *)context;
@end
