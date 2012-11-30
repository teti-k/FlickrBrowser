//
//  TagsViewController.m
//  FlickrBrowser
//
//  Created by Zshcbka on 11/7/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "TagsViewController.h"
#import "Tag.h"
#import "CoreDataTableViewController.h"
#import "VacationHelper.h"
#import "VacationPhotoListController.h"
#import "VacationViewController.h"

@interface TagsViewController ()

@end

@implementation TagsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Vacation by tags";
    [self useDocument];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setVacationDatabase:(UIManagedDocument *)vacationDatabase
{
    if (_vacationDatabase != vacationDatabase)
    {
        _vacationDatabase = vacationDatabase;
    }
    
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
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:vacation.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Tags cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tag.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"number of tagged pictures %d", [tag.photos count]];
    return cell;
}

#pragma mark - Table view delegate

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Show tagged photo"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        VacationPhotoListController *dest = [segue destinationViewController];
        Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
        dest.photos = tag.photos;
        dest.title = tag.name;
        dest.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
    }
}

@end
