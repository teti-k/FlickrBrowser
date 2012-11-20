//
//  TagsViewController.h
//  FlickrBrowser
//
//  Created by Zshcbka on 11/7/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface TagsViewController : CoreDataTableViewController
@property (nonatomic,strong) UIManagedDocument *vacationDatabase; //the database of vacation plans
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSString *vacationPlanName;
@end
