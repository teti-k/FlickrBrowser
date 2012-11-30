//
//  FirstTableViewController.m
//  FlickrBrowser
//
//  Created by Zshcbka on 9/29/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "FirstTableViewController.h"
#import "FlickrFetcher.h"
#import "TopPhotoViewController.h"
#import "MapViewController.h"
#import "FlickrPhotoAnnotation.h"


@interface FirstTableViewController () <UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation FirstTableViewController

- (void)setPhotos:(NSArray *)photos
{
    if (_photos != photos) {
        _photos = photos;
        // Model changed, so update our View (the table)
        [self.tableView reloadData];
    }
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

//push button to receive top places 
- (IBAction)refresh:(id)sender
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *photos = [FlickrFetcher topPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem = sender;
            self.photos = photos;
        });
    });
    dispatch_release(downloadQueue);
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photos count]];
    for (NSDictionary *photo in self.photos) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

//button switches to map
- (IBAction)segmentControlChanged:(UISegmentedControl *)sender
{

    switch (self.segmentControl.selectedSegmentIndex)
    {
        case 0:
            break;
        case 1:
        {
            MapViewController *mapViewController = [[UIStoryboard storyboardWithName:@"iPhoneStoryboard" bundle:NULL] instantiateViewControllerWithIdentifier:@"mapViewController"];
            
            [self.navigationController pushViewController:mapViewController animated:YES];
            [self.segmentControl setSelectedSegmentIndex:0];
            mapViewController.annotations = self.mapAnnotations;
           // mapViewController.delegate = self;
        }
        default:
            break;
    }  
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Flickr Top Place";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *photo = (self.photos)[indexPath.row];
    cell.textLabel.text = [photo valueForKeyPath:@"woe_name"];
    cell.detailTextLabel.text = photo[FLICKR_PLACE_NAME];
    
    
    return cell;

}

//By this segue the list of photos for selected location will be displayed.
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"selectLocation"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

        TopPhotoViewController *dest = [segue destinationViewController];
        dest.selectedLocation = (self.photos)[indexPath.row];
        dest.title = [[sender textLabel] text];
        dest.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];

    }
}



@end
