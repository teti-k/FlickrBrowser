//
//  VisitUnvisitButtonController.m
//  FlickrBrowser
//
//  Created by Zshcbka on 11/12/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "VisitUnvisitButtonController.h"
#import "FlickrFetcher.h"
#import "CoreDataTableViewController.h"
#import "VacationHelper.h"
#import "ShowImageViewController.h"

@implementation VisitUnvisitButtonController
BOOL imageToVisit;


+(UIButton *)configureButton: (UIButton *)button forImage: (NSDictionary *)flickrInfo
{
    [VacationHelper openVacation:@"My Vacation Database" usingBlock:^(UIManagedDocument *vacation)
     {
         NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
         request.predicate = [NSPredicate predicateWithFormat:@"unique = %@",[flickrInfo objectForKey:FLICKR_PHOTO_ID]];
         NSError *error = nil;
         NSArray *matches = [vacation.managedObjectContext executeFetchRequest:request error:&error];
         ShowImageViewController *sivc = [[ShowImageViewController alloc] init];
         if (matches.count == 0)
         {
             [button setTitle:@"Visit" forState:UIControlStateNormal];
             [button addTarget:sivc
                        action:@selector(useDocument)
              forControlEvents:UIControlEventTouchUpInside];
         } else if (!matches.count == 0)
         {
             [button setTitle:@"Unvisit" forState:UIControlStateNormal];
             [button addTarget:sivc
                        action:@selector(deleteDocument)
              forControlEvents:UIControlEventTouchUpInside];
         }
     }];
   return button;
}

@end
