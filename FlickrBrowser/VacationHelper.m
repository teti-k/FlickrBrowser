//
//  VacationHelper.m
//  FlickrBrowser
//
//  Created by Zshcbka on 11/6/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "VacationHelper.h"
#import "Photo+Flickr.h"
#import "FlickrFetcher.h"


@implementation VacationHelper

+ (void)openVacation:(NSString *)vacationName
          usingBlock:(completion_block_t)completionBlock
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:vacationName];
    UIManagedDocument *doc = [[UIManagedDocument alloc] initWithFileURL:url];
    NSMutableArray *vacationsArray = [[[NSUserDefaults standardUserDefaults] objectForKey:VACATION_PLANS_ARRAY] mutableCopy];
    if (!vacationsArray) vacationsArray = [NSMutableArray array];
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        [doc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:NULL];
        [doc openWithCompletionHandler:NULL];
        
        [vacationsArray addObject:vacationName];
        [[NSUserDefaults standardUserDefaults] setObject:vacationsArray forKey:VACATION_PLANS_ARRAY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(doc.documentState == UIDocumentStateClosed)
    {
        [doc openWithCompletionHandler:^(BOOL success){
            completionBlock(doc);
        }];
    }
}

@end
