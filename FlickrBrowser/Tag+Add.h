//
//  Tag+Add.h
//  FlickrBrowser
//
//  Created by Zshcbka on 11/7/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "Tag.h"

@interface Tag (Add)
+ (NSSet *) tagNames:(NSString *)names
        inManagedObjectContext:(NSManagedObjectContext *)context;
@end
