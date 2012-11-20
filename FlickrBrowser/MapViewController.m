//
//  MapViewController.m
//  FlickrBrowser
//
//  Created by Zshcbka on 10/17/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "MapViewController.h"
#import "FlickrPhotoAnnotation.h"
#import "ShowImageViewController.h"
#import "FlickrFetcher.h"
#import "TopPhotoViewController.h"

@interface MapViewController () <MKMapViewDelegate>
@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.mapView.delegate = self;

}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
    
}

- (void) updateMapView
{
  
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
    [self moveToRegion];
    
}

-(void) setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

-(void) setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

- (void)moveToRegion
{
    double minLatitude  = 0;
    double maxLatitude  = 90;
    double minLongitude = -179;
    double maxLongitude = 180;
    
    if (self.annotations.count > 0) {
        
        // Use first annotation as intial reference
        FlickrPhotoAnnotation *annotation = [self.annotations objectAtIndex:0];
        minLatitude  = annotation.coordinate.latitude;
        maxLatitude  = annotation.coordinate.latitude;
        minLongitude = annotation.coordinate.longitude;
        maxLongitude = annotation.coordinate.longitude;
        
        // Compare against all annotations
        for (FlickrPhotoAnnotation *annotation in self.annotations) {
            if (annotation.coordinate.latitude  < minLatitude)  minLatitude  = annotation.coordinate.latitude;
            if (annotation.coordinate.latitude  > maxLatitude)  maxLatitude  = annotation.coordinate.latitude;
            if (annotation.coordinate.longitude < minLongitude) minLongitude = annotation.coordinate.longitude;
            if (annotation.coordinate.longitude > maxLongitude) maxLongitude = annotation.coordinate.longitude;
        }
    }
    
    // Calculate the center of the region
    double latitudeDelta   = (maxLatitude  - minLatitude);
    double longitudeDelta  = (maxLongitude - minLongitude);
    double centerLatitude  = latitudeDelta  / 2 + minLatitude;
    double centerLongitude = longitudeDelta / 2 + minLongitude;
    
    // Set region by the min and max values, with comfortable padding
    CLLocationCoordinate2D coord = {.latitude = centerLatitude, .longitude = centerLongitude};
    MKCoordinateSpan span = {.latitudeDelta = latitudeDelta + 0.012, .longitudeDelta = longitudeDelta + 0.012};
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        

    }
    
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
    FlickrPhotoAnnotation *viewAnnotation;
    viewAnnotation = view.annotation;
    if (viewAnnotation.subtitle)
    {
    if (! UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
       ShowImageViewController *sivc = [[UIStoryboard storyboardWithName:@"iPhoneStoryboard" bundle:NULL] instantiateViewControllerWithIdentifier:@"showImageVC"];
    
       [self.navigationController pushViewController:sivc animated:NO];
       sivc.selectedImage = viewAnnotation.photo;
       sivc.imageTitle = viewAnnotation.title;
    }
    else
        {
       //send photo to ShowImageVC if it is in SplitView
            if ([self splitViewShowImageVC])
            {
                [self splitViewShowImageVC].selectedImage = viewAnnotation.photo;
                [[self splitViewShowImageVC] downloadImage:[self splitViewShowImageVC].selectedImage];
                [self splitViewShowImageVC].imageTitle = [viewAnnotation.photo objectForKey:FLICKR_PHOTO_DESCRIPTION];
            }
        }
    }
    
    else
    {
        TopPhotoViewController *tpvc = [[UIStoryboard storyboardWithName:@"iPhoneStoryboard" bundle:NULL] instantiateViewControllerWithIdentifier:@"topPhotoVC"];
            
        [self.navigationController pushViewController:tpvc animated:NO];
        tpvc.selectedLocation = viewAnnotation.photo;
        tpvc.title = [viewAnnotation.photo objectForKey:FLICKR_PLACE_NAME];
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


- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
