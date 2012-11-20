//
//  FlickrPhotoAnnotation.m
//  FlickrBrowser
//
//  Created by Zshcbka on 10/17/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPhotoAnnotation

+ (FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo
{
    FlickrPhotoAnnotation *annotation = [[FlickrPhotoAnnotation alloc] init];
    annotation.photo = photo; 
    return annotation;
}

-(NSString *) title
{

    if ([self.photo objectForKey:FLICKR_PHOTO_TITLE])
    return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
    else return [self.photo objectForKey:FLICKR_PLACE_NAME];
}

-(NSString *) subtitle
{
    return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}
-(CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

@end
