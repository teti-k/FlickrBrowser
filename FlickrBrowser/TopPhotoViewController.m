//
//  TopPhotoViewController.m
//  FlickrBrowser
//
//  Created by Zshcbka on 10/5/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "TopPhotoViewController.h"
#import "FlickrFetcher.h"
#import "FirstTableViewController.h"
#import "ShowImageViewController.h"
#import "SecondTableViewController.h"
#import "MapViewController.h"
#import "FlickrPhotoAnnotation.h"

@interface TopPhotoViewController () <MapViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentControl;
@end

@implementation TopPhotoViewController

int const resonableRecents = 15; //amount of recently viewed photos to show in SecondVC



- (void)viewDidLoad
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *photos = [FlickrFetcher photosInPlace:self.selectedLocation maxResults:50];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = photos;
        });
    });
    dispatch_release(downloadQueue);
    self.navigationItem.title = self.title;
    [super viewDidLoad];
    
}

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

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photos count]];
    for (NSDictionary *photo in self.photos) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    
    FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)annotation;
    NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data ? [UIImage imageWithData:data] : nil;
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
            mapViewController.centerCoordinate = [self coordinate];
            mapViewController.delegate = self;
        }
        default:
            break;
    }
}

- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.selectedLocation objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.selectedLocation objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Foto in location";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    if ([photo valueForKeyPath:@"title"]) {
        cell.textLabel.text = [photo valueForKeyPath:@"title"];
    }
    else cell.textLabel.text = @"Untitled";
    cell.detailTextLabel.text = [photo objectForKey:FLICKR_PHOTO_OWNER];
    
    return cell;
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    // saveToRecents
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recents = [[defaults valueForKey:@"FAVOURITES_KEY"] mutableCopy];
    if ( recents == nil ) recents = [NSMutableArray array];
    for (int i=0; i<recents.count; i++)
    {
        NSString *rec_value = (NSString *)[[recents objectAtIndex:i] objectForKey:FLICKR_PHOTO_ID];
        NSString *photo_value = (NSString *)[photo objectForKey:FLICKR_PHOTO_ID];
        if ([rec_value isEqualToString:photo_value]) {
            [recents removeObjectAtIndex:i];
        }
    }
    [recents addObject:photo];
    
    if ([recents count] > resonableRecents)
    {
        [recents removeObjectAtIndex:0];
    }
    [defaults setObject:recents forKey:@"FAVOURITES_KEY"];
    [defaults synchronize];
    

    
    //send photo to ShowImageVC if it is in SplitView 
    if ([self splitViewShowImageVC])
    {
        [self splitViewShowImageVC].selectedImage = photo;
        [[self splitViewShowImageVC] downloadImage:[self splitViewShowImageVC].selectedImage];
        [self splitViewShowImageVC].imageTitle = [photo objectForKey:FLICKR_PHOTO_DESCRIPTION];
    }
}

- (ShowImageViewController *) splitViewShowImageVC
{
    id sivc = [self.splitViewController.viewControllers lastObject];
    if (![sivc isKindOfClass:[ShowImageViewController class]]) {
        sivc = nil;
    }
    return sivc;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"showTopPicture"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        ShowImageViewController *dest = [segue destinationViewController];
        dest.imageTitle = [[sender textLabel] text];
        dest.selectedImage = [self.photos objectAtIndex:indexPath.row];        
        dest.hidesBottomBarWhenPushed = YES; //hide tabs
    }
}
 
@end
