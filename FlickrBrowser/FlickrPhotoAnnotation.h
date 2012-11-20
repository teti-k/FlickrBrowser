//
//  FlickrPhotoAnnotation.h
//  FlickrBrowser
//
//  Created by Zshcbka on 10/17/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface FlickrPhotoAnnotation : NSObject <MKAnnotation>

+ (FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo; // Flickr photo dictionary

@property (nonatomic,weak) NSDictionary *photo; //Flickr photo 

@end
