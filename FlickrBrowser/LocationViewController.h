//
//  VacationViewController.h
//  FlickrBrowser
//
//  Created by Zshcbka on 10/22/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface LocationViewController : CoreDataTableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
