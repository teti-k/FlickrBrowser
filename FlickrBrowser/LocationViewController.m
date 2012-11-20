//
//  VacationViewController.m
//  FlickrBrowser
//
//  Created by Zshcbka on 10/22/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "LocationViewController.h"
#import "FlickrFetcher.h"
#import "Location.h"
#import "VacationHelper.h"
#import "VacationPhotoListController.h"
#import "VacationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Vacation by cities";
    [self useDocument];
    

}

-(void) useDocument
{
    [VacationHelper openVacation:vacationPlan usingBlock:^(UIManagedDocument *vacation){
        [self setupFetchedResultsController:vacation];
        [vacation saveToURL:vacation.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:Nil];
    }];
}


- (void) setupFetchedResultsController:(UIManagedDocument *)vacation
{
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:vacation.managedObjectContext
                                                                        sectionNameKeyPath:nil
                                                                        cacheName:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Location Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // ask NSFetchedResultsController for the NSMO at the row in question
    Location *location = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = location.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [location.photos count]];
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Show iternity location"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        VacationPhotoListController *dest = [segue destinationViewController];
        Location *location = [self.fetchedResultsController objectAtIndexPath:indexPath];
        dest.photos = location.photos;
        dest.title = location.name;

    }
}


@end
