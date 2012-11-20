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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *vacationPlans = [[defaults objectForKey:VACATION_PLANS_ARRAY] mutableCopy];
    if (!vacationPlans) vacationPlans = [NSMutableArray array];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        [doc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:NULL];
        [doc openWithCompletionHandler:NULL];
        [vacationPlans addObject:vacationName];
        [defaults setObject:vacationPlans forKey:VACATION_PLANS_ARRAY];
        [defaults synchronize];
       // NSLog(@"VacationPlans from Vacation helper %@", vacationPlans.lastObject);

    }
    else if(doc.documentState == UIDocumentStateClosed)
    {
        [doc openWithCompletionHandler:^(BOOL success){
            completionBlock(doc);
        }];
       // NSLog(@"VacationPlans from Vacation helper %@", vacationPlans.lastObject);
    }
}

@end
