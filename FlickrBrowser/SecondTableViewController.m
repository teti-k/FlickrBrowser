//
//  SecondTableViewController.m
//  FlickrBrowser
//
//  Created by Zshcbka on 9/29/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "SecondTableViewController.h"
#import "FlickrFetcher.h"
#import "ShowImageViewController.h"
#import "TopPhotoViewController.h"
#import "MapViewController.h"
#import "FlickrPhotoAnnotation.h"

@interface SecondTableViewController () <MapViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation SecondTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recents = [[defaults valueForKey:@"FAVOURITES_KEY"] mutableCopy];
    
    //reverse recents array to display photos from recently viewed to old 
    _photos = [[recents reverseObjectEnumerator] allObjects];
    //_photos = recents;
    
    [self.tableView reloadData];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[_photos count]];
    for (NSDictionary *photo in _photos) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

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
            mapViewController.delegate = self;
        }
        default:
            break;
    }
}

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    
    FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)annotation;
    NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data ? [UIImage imageWithData:data] : nil;
}

#pragma mark - Table view data source
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger *)section
{
    return [_photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Recent Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    NSDictionary *photos = _photos[indexPath.row];
    cell.textLabel.text = photos[FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = photos[FLICKR_PLACE_NAME];
    return cell;
}

- (ShowImageViewController *) splitViewShowImageVC
{
    id sivc = [self.splitViewController.viewControllers lastObject];
    if (![sivc isKindOfClass:[ShowImageViewController class]]) {
        sivc = nil;
    }
    return sivc;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self splitViewShowImageVC])
    {
       [self splitViewShowImageVC].selectedImage = _photos[indexPath.row];
        [[self splitViewShowImageVC] downloadImage:[self splitViewShowImageVC].selectedImage];
    }
}

//show selected image
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"showRecentImage"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        ShowImageViewController *dest = [segue destinationViewController];
        dest.selectedImage = _photos[indexPath.row];
        dest.imageTitle = [[sender textLabel] text];        
        dest.hidesBottomBarWhenPushed = YES; //hide tabs
        dest.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        
    }
}

@end
